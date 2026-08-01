# Clinical AI Agent Research Skill

面向临床决策支持、疾病识别/预测、多模态医疗数据和多智能体研究的可移植 Agent Skill。默认工作层级是患者、就诊、队列、机构和临床流程；细胞、patch、标本及组学数据仅作为可选嵌套模态。

仓库包含一个定制编排 skill，以及 15 个经过筛选的上游 skill 的固定版本清单。安装脚本使用 Git sparse checkout 获取指定提交和目录，不会安装全局 Python 包，也不会默认安装 Scanpy、PathML 或 DeepChem。

## Windows：同时安装到 Codex 和 Claude Code

先安装 Git for Windows，然后在 PowerShell 中运行：

```powershell
gh repo clone wenzhihong168/clinical-ai-agent-research-skill
Set-Location clinical-ai-agent-research-skill
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Target All
```

安装位置：

- Codex：`%USERPROFILE%\.agents\skills`
- Claude Code：`%USERPROFILE%\.claude\skills`

只安装某一端：

```powershell
.\install.ps1 -Target Codex
.\install.ps1 -Target ClaudeCode
```

只安装定制 skill、不拉取依赖：

```powershell
.\install.ps1 -Target All -SkipDependencies
```

## macOS/Linux

```bash
gh repo clone wenzhihong168/clinical-ai-agent-research-skill
cd clinical-ai-agent-research-skill
bash install.sh --target all
```

可选目标为 `all`、`codex` 或 `claude`。

## 调用

- Codex：`$clinical-ai-agent-research`
- Claude Code：`/clinical-ai-agent-research`

可直接交给另一台电脑上 Agent 的完整部署提示词见 [`DEPLOYMENT_PROMPTS.md`](DEPLOYMENT_PROMPTS.md)。

示例：

```text
使用 clinical-ai-agent-research，设计一项多中心、多模态疾病预测研究。先冻结研究问题、结局、索引时间和数据层级，再给出患者/中心/时间泄漏安全的验证方案、基线、消融、临床与 Agent 指标、顶刊写作和绘图计划。不要处理真实 PHI，不要用于患者个体诊疗。
```

## 安全设计

- 上游仓库固定到 `upstream-skills.lock.json` 中的完整 Git 提交。
- 更新已有 skill 前先把旧目录移动到同一 skills 根目录下的 `.clinical-ai-agent-research-backups/<时间戳>`。
- 临床数据、PHI、未发表稿件和保密架构默认仅在本地处理。
- 定量科研图必须由真实数据和确定性代码生成。
- 所有临床输出均为研究草稿，要求合格的人类专家复核。

## 更新

重新拉取本仓库后再次运行安装脚本。不要自行把 lock 文件中的提交改为移动分支；先审查许可证、脚本、权限、网络行为和依赖变化，再更新固定提交。
