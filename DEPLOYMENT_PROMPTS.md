# Deployment prompts

## Windows Codex

```text
请把 GitHub 仓库 wenzhihong168/clinical-ai-agent-research-skill 中的科研 skills 安装到这台 Windows 电脑的 Codex 全局 skills 目录。

要求：
1. 先检查 Git for Windows 和 GitHub CLI；如果仓库是私有的，运行 gh auth status，未登录时引导我完成 gh auth login，不要索要或显示 token。
2. 克隆仓库后，先审查 README.md、SECURITY.md、install.ps1 和 upstream-skills.lock.json。
3. 确认上游依赖固定到完整的 40 位 Git commit，不要改用 main/master 或最新版。
4. 在仓库根目录运行：
   powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Target Codex
5. 安装目录应为 $env:USERPROFILE\.agents\skills。
6. 验证 clinical-ai-agent-research 和 15 个依赖目录均包含 SKILL.md，并报告缺失项；不要安装 Scanpy、PathML、DeepChem，也不要全局安装 Python/Node 包。
7. 不要读取或上传任何患者数据、PHI、未发表论文或密钥。
8. 安装完成后告诉我是否需要重新启动 Codex，并给出调用示例：$clinical-ai-agent-research。
```

## Claude Code

```text
请把 GitHub 仓库 wenzhihong168/clinical-ai-agent-research-skill 中的科研 skills 安装为我的 Claude Code 个人 skills。

要求：
1. 先检查 Git 和 GitHub 身份；如果仓库是私有的，使用 gh auth login 的安全交互流程，不要让我把 token 粘贴到聊天中。
2. 克隆后审查 README.md、SECURITY.md、对应操作系统的安装脚本和 upstream-skills.lock.json。只接受锁文件中的完整 Git commits。
3. Windows 在仓库根目录运行：
   powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Target ClaudeCode
   macOS/Linux 运行：
   bash install.sh --target claude
4. 安装目录应为 ~/.claude/skills；验证 clinical-ai-agent-research 和 15 个依赖均有 SKILL.md。
5. 不要安装 Scanpy、PathML、DeepChem，不要全局安装重型运行时，也不要授权外部服务读取 PHI、未发表稿件或保密模型资料。
6. 如果 ~/.claude/skills 是本次新建的顶层目录，提醒我重启 Claude Code；否则检查 skills 是否已实时发现。
7. 安装完成后用 /clinical-ai-agent-research 做一次只读 smoke test：输出一个“多中心多模态疾病预测研究”的研究合同、泄漏安全切分框架和评估指标清单，但不要生成患者个体建议。
```

## 同一台 Windows 同时安装两端

```text
请从私有 GitHub 仓库 wenzhihong168/clinical-ai-agent-research-skill 安全安装整套科研 skills，同时部署到 Windows Codex 的 $env:USERPROFILE\.agents\skills 和 Claude Code 的 $env:USERPROFILE\.claude\skills。先验证 GitHub 登录并审查安装器与固定 commit 锁文件，然后在仓库根目录运行 powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Target All。完成后验证两端各有 16 个含 SKILL.md 的 skill 目录，报告备份位置和任何失败项；不要安装细胞级重型栈或全局运行时，不要处理任何 PHI 或密钥。
```
