[CmdletBinding()]
param(
    [ValidateSet("All", "Codex", "ClaudeCode")]
    [string]$Target = "All",

    [switch]$SkipDependencies,

    [string]$CodexRoot = (Join-Path $env:USERPROFILE ".agents\skills"),

    [string]$ClaudeRoot = (Join-Path $env:USERPROFILE ".claude\skills")
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$CustomSkillSource = Join-Path $ScriptRoot "clinical-ai-agent-research"
$KDenseRepository = "https://github.com/K-Dense-AI/claude-scientific-skills.git"
$KDenseCommit = "ab2f84ab10597c59fac186ecda6d5edd5dcc8b92"
$OrchestraRepository = "https://github.com/Orchestra-Research/AI-Research-SKILLs.git"
$OrchestraCommit = "773a52944ba4747a18bd4ae9ade53fff041adcbc"

$KDenseSkills = @(
    @{ Source = "skills/paper-lookup"; Destination = "paper-lookup" },
    @{ Source = "skills/scientific-writing"; Destination = "scientific-writing" },
    @{ Source = "skills/peer-review"; Destination = "peer-review" },
    @{ Source = "skills/statistical-analysis"; Destination = "statistical-analysis" },
    @{ Source = "skills/scientific-visualization"; Destination = "scientific-visualization" },
    @{ Source = "skills/clinical-decision-support"; Destination = "clinical-decision-support" },
    @{ Source = "skills/experimental-design"; Destination = "experimental-design" },
    @{ Source = "skills/scikit-learn"; Destination = "scikit-learn" },
    @{ Source = "skills/pytorch-lightning"; Destination = "pytorch-lightning" }
)

$OrchestraSkills = @(
    @{ Source = "20-ml-paper-writing/ml-paper-writing"; Destination = "ml-paper-writing" },
    @{ Source = "20-ml-paper-writing/academic-plotting"; Destination = "academic-plotting" },
    @{ Source = "14-agents/langchain"; Destination = "langchain" },
    @{ Source = "14-agents/llamaindex"; Destination = "llamaindex" },
    @{ Source = "14-agents/crewai"; Destination = "crewai-multi-agent" },
    @{ Source = "11-evaluation/lm-evaluation-harness"; Destination = "evaluating-llms-harness" }
)

function Invoke-CheckedGit {
    param([Parameter(Mandatory = $true)][string[]]$Arguments)

    & git @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "git command failed: git $($Arguments -join ' ')"
    }
}

function Invoke-CheckedGitWithRetry {
    param(
        [Parameter(Mandatory = $true)][string[]]$Arguments,
        [int]$Attempts = 4
    )

    for ($Attempt = 1; $Attempt -le $Attempts; $Attempt++) {
        & git @Arguments
        if ($LASTEXITCODE -eq 0) {
            return
        }
        if ($Attempt -lt $Attempts) {
            Start-Sleep -Seconds (2 * $Attempt)
        }
    }
    throw "git command failed after $Attempts attempts: git $($Arguments -join ' ')"
}

function Get-PinnedSparseRepository {
    param(
        [Parameter(Mandatory = $true)][string]$Repository,
        [Parameter(Mandatory = $true)][string]$Commit,
        [Parameter(Mandatory = $true)][object[]]$Skills,
        [Parameter(Mandatory = $true)][string]$Destination
    )

    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    Invoke-CheckedGit -Arguments @("-C", $Destination, "init", "--quiet")
    Invoke-CheckedGit -Arguments @("-C", $Destination, "remote", "add", "origin", $Repository)
    Invoke-CheckedGit -Arguments @("-C", $Destination, "config", "remote.origin.promisor", "true")
    Invoke-CheckedGit -Arguments @("-C", $Destination, "config", "remote.origin.partialclonefilter", "blob:none")
    Invoke-CheckedGit -Arguments @("-C", $Destination, "sparse-checkout", "init", "--cone")

    [string[]]$Paths = $Skills | ForEach-Object { [string]$_.Source }
    Invoke-CheckedGit -Arguments (@("-C", $Destination, "sparse-checkout", "set") + $Paths)
    Invoke-CheckedGitWithRetry -Arguments @("-C", $Destination, "fetch", "--depth", "1", "--filter=blob:none", "origin", $Commit)
    Invoke-CheckedGitWithRetry -Arguments @("-C", $Destination, "checkout", "--detach", "FETCH_HEAD")

    $Resolved = ((& git -C $Destination rev-parse HEAD) | Out-String).Trim()
    if ($LASTEXITCODE -ne 0 -or $Resolved -ne $Commit) {
        throw "Pinned commit verification failed for $Repository. Expected $Commit, got $Resolved."
    }
}

function Install-SkillFolder {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string]$Root,
        [Parameter(Mandatory = $true)][string]$BackupStamp
    )

    if (-not (Test-Path -LiteralPath (Join-Path $Source "SKILL.md"))) {
        throw "Invalid skill source: $Source"
    }

    New-Item -ItemType Directory -Path $Root -Force | Out-Null
    $Destination = Join-Path $Root $Name

    if (Test-Path -LiteralPath $Destination) {
        $BackupRoot = Join-Path $Root ".clinical-ai-agent-research-backups\$BackupStamp"
        New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null
        Move-Item -LiteralPath $Destination -Destination (Join-Path $BackupRoot $Name)
    }

    Copy-Item -LiteralPath $Source -Destination $Destination -Recurse -Force
    if (-not (Test-Path -LiteralPath (Join-Path $Destination "SKILL.md"))) {
        throw "Installation verification failed: $Destination"
    }
    Write-Host "Installed $Name -> $Destination"
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is required. Install Git for Windows, then rerun this script."
}

if (-not (Test-Path -LiteralPath (Join-Path $CustomSkillSource "SKILL.md"))) {
    throw "Run this installer from the cloned repository; the custom skill folder is missing."
}

$InstallRoots = @()
if ($Target -eq "All" -or $Target -eq "Codex") {
    $InstallRoots += $CodexRoot
}
if ($Target -eq "All" -or $Target -eq "ClaudeCode") {
    $InstallRoots += $ClaudeRoot
}

$BackupStamp = Get-Date -Format "yyyyMMdd-HHmmss"
$TemporaryRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("clinical-ai-agent-research-" + [guid]::NewGuid().ToString("N"))

try {
    New-Item -ItemType Directory -Path $TemporaryRoot -Force | Out-Null

    if (-not $SkipDependencies) {
        $KDenseCheckout = Join-Path $TemporaryRoot "kdense"
        $OrchestraCheckout = Join-Path $TemporaryRoot "orchestra"
        Get-PinnedSparseRepository -Repository $KDenseRepository -Commit $KDenseCommit -Skills $KDenseSkills -Destination $KDenseCheckout
        Get-PinnedSparseRepository -Repository $OrchestraRepository -Commit $OrchestraCommit -Skills $OrchestraSkills -Destination $OrchestraCheckout
    }

    foreach ($Root in $InstallRoots) {
        Install-SkillFolder -Source $CustomSkillSource -Name "clinical-ai-agent-research" -Root $Root -BackupStamp $BackupStamp
    }

    if (-not $SkipDependencies) {
        foreach ($Root in $InstallRoots) {
            foreach ($Skill in $KDenseSkills) {
                Install-SkillFolder -Source (Join-Path $KDenseCheckout $Skill.Source) -Name $Skill.Destination -Root $Root -BackupStamp $BackupStamp
            }
            foreach ($Skill in $OrchestraSkills) {
                Install-SkillFolder -Source (Join-Path $OrchestraCheckout $Skill.Source) -Name $Skill.Destination -Root $Root -BackupStamp $BackupStamp
            }
        }
    }
}
finally {
    if (Test-Path -LiteralPath $TemporaryRoot) {
        Remove-Item -LiteralPath $TemporaryRoot -Recurse -Force
    }
}

Write-Host "Installation complete. Codex: `$clinical-ai-agent-research; Claude Code: /clinical-ai-agent-research"
