#!/usr/bin/env bash
set -euo pipefail

script_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
target="all"
skip_dependencies=0
codex_root="${HOME}/.agents/skills"
claude_root="${HOME}/.claude/skills"

usage() {
  echo "Usage: $0 [--target all|codex|claude] [--skip-dependencies] [--codex-root PATH] [--claude-root PATH]"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      target="$2"
      shift 2
      ;;
    --skip-dependencies)
      skip_dependencies=1
      shift
      ;;
    --codex-root)
      codex_root="$2"
      shift 2
      ;;
    --claude-root)
      claude_root="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ "$target" != "all" && "$target" != "codex" && "$target" != "claude" ]]; then
  echo "Invalid target: $target" >&2
  exit 2
fi

command -v git >/dev/null 2>&1 || {
  echo "Git is required." >&2
  exit 1
}

custom_skill_source="${script_root}/clinical-ai-agent-research"
[[ -f "${custom_skill_source}/SKILL.md" ]] || {
  echo "Run this installer from the cloned repository; the custom skill folder is missing." >&2
  exit 1
}

kdense_repository="https://github.com/K-Dense-AI/claude-scientific-skills.git"
kdense_commit="ab2f84ab10597c59fac186ecda6d5edd5dcc8b92"
orchestra_repository="https://github.com/Orchestra-Research/AI-Research-SKILLs.git"
orchestra_commit="773a52944ba4747a18bd4ae9ade53fff041adcbc"

kdense_skills=(
  "paper-lookup=skills/paper-lookup"
  "scientific-writing=skills/scientific-writing"
  "peer-review=skills/peer-review"
  "statistical-analysis=skills/statistical-analysis"
  "scientific-visualization=skills/scientific-visualization"
  "clinical-decision-support=skills/clinical-decision-support"
  "experimental-design=skills/experimental-design"
  "scikit-learn=skills/scikit-learn"
  "pytorch-lightning=skills/pytorch-lightning"
)

orchestra_skills=(
  "ml-paper-writing=20-ml-paper-writing/ml-paper-writing"
  "academic-plotting=20-ml-paper-writing/academic-plotting"
  "langchain=14-agents/langchain"
  "llamaindex=14-agents/llamaindex"
  "crewai-multi-agent=14-agents/crewai"
  "evaluating-llms-harness=11-evaluation/lm-evaluation-harness"
)

install_roots=()
if [[ "$target" == "all" || "$target" == "codex" ]]; then
  install_roots+=("$codex_root")
fi
if [[ "$target" == "all" || "$target" == "claude" ]]; then
  install_roots+=("$claude_root")
fi

backup_stamp="$(date +%Y%m%d-%H%M%S)"
temporary_root="$(mktemp -d "${TMPDIR:-/tmp}/clinical-ai-agent-research.XXXXXX")"
cleanup() {
  if [[ -n "${temporary_root:-}" && -d "$temporary_root" ]]; then
    rm -rf -- "$temporary_root"
  fi
}
trap cleanup EXIT

git_with_retry() {
  local repository_dir="$1"
  shift
  local attempt
  for attempt in 1 2 3 4; do
    if git -C "$repository_dir" "$@"; then
      return 0
    fi
    if [[ "$attempt" -lt 4 ]]; then
      sleep $((attempt * 2))
    fi
  done
  echo "git command failed after 4 attempts: git -C $repository_dir $*" >&2
  return 1
}

get_pinned_sparse_repository() {
  local repository="$1"
  local commit="$2"
  local destination="$3"
  shift 3
  local specs=("$@")
  local paths=()
  local spec

  mkdir -p "$destination"
  git -C "$destination" init --quiet
  git -C "$destination" remote add origin "$repository"
  git -C "$destination" config remote.origin.promisor true
  git -C "$destination" config remote.origin.partialclonefilter blob:none
  git -C "$destination" sparse-checkout init --cone
  for spec in "${specs[@]}"; do
    paths+=("${spec#*=}")
  done
  git -C "$destination" sparse-checkout set "${paths[@]}"
  git_with_retry "$destination" fetch --depth 1 --filter=blob:none origin "$commit"
  git_with_retry "$destination" -c advice.detachedHead=false checkout --detach FETCH_HEAD

  local resolved
  resolved="$(git -C "$destination" rev-parse HEAD)"
  [[ "$resolved" == "$commit" ]] || {
    echo "Pinned commit verification failed for $repository" >&2
    exit 1
  }
}

install_skill_folder() {
  local source="$1"
  local name="$2"
  local root="$3"
  local destination="${root}/${name}"
  local backup_root="${root}/.clinical-ai-agent-research-backups/${backup_stamp}"

  [[ -f "${source}/SKILL.md" ]] || {
    echo "Invalid skill source: $source" >&2
    exit 1
  }

  mkdir -p "$root"
  if [[ -e "$destination" ]]; then
    mkdir -p "$backup_root"
    mv -- "$destination" "${backup_root}/${name}"
  fi
  cp -R -- "$source" "$destination"
  [[ -f "${destination}/SKILL.md" ]] || {
    echo "Installation verification failed: $destination" >&2
    exit 1
  }
  echo "Installed ${name} -> ${destination}"
}

if [[ "$skip_dependencies" -eq 0 ]]; then
  kdense_checkout="${temporary_root}/kdense"
  orchestra_checkout="${temporary_root}/orchestra"
  get_pinned_sparse_repository "$kdense_repository" "$kdense_commit" "$kdense_checkout" "${kdense_skills[@]}"
  get_pinned_sparse_repository "$orchestra_repository" "$orchestra_commit" "$orchestra_checkout" "${orchestra_skills[@]}"
fi

for root in "${install_roots[@]}"; do
  install_skill_folder "$custom_skill_source" "clinical-ai-agent-research" "$root"
done

if [[ "$skip_dependencies" -eq 0 ]]; then
  for root in "${install_roots[@]}"; do
    for spec in "${kdense_skills[@]}"; do
      install_skill_folder "${kdense_checkout}/${spec#*=}" "${spec%%=*}" "$root"
    done
    for spec in "${orchestra_skills[@]}"; do
      install_skill_folder "${orchestra_checkout}/${spec#*=}" "${spec%%=*}" "$root"
    done
  done
fi

echo 'Installation complete. Codex: $clinical-ai-agent-research; Claude Code: /clinical-ai-agent-research'
