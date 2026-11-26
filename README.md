# Agent CLI 全局工程准则

让多个编程助手共用一份工程准则，涵盖改动范围、测试分工、验证和交付。安装时使用英文原稿，维护者可以阅读简体中文译本。[英文原稿](SKILL.md) · [简体中文译本](SKILL.zh-CN.md)

## 安装与使用

在仓库根目录使用 GNU Make。以下示例为 Codex 和 Claude Code 安装同一份准则。

```sh
make install
make link codex claude
```

- `make install` 将 `SKILL.md` 复制到 `~/.agents/AGENTS.md`，自动创建目录并覆盖已有文件。直接运行 `make` 也会执行安装。
- `make link` 后面填写一个或多个 agent 名称，以空格分隔。它会在各自的全局指令路径创建指向 `~/.agents/AGENTS.md` 的软链接。已有文件、目录或软链接（包括失效链接）都会跳过。
- 更新仓库中的准则后，再运行一次 `make install` 即可更新所有已建链接指向的内容。运行 `make help` 可查看命令和支持的名称。

## 支持的 agent

| 命令行名称 | 编程助手 | 全局指令路径 |
| --- | --- | --- |
| `codex` | Codex CLI | `~/.codex/AGENTS.md` |
| `claude` | Claude Code | `~/.claude/CLAUDE.md` |
| `gemini`、`agy` | Gemini CLI、Google Antigravity CLI | `~/.gemini/GEMINI.md` |
| `opencode` | OpenCode | `~/.config/opencode/AGENTS.md` |
| `copilot` | GitHub Copilot CLI | `~/.copilot/copilot-instructions.md` |

Gemini CLI 和 Antigravity CLI 共用同一路径，执行一次 `make link agy` 即可为两者建链。

## 维护准则

修改准则时，先更新英文原稿，再在同一次改动中同步简体中文译本。提交前的双语核对要求见[仓库维护约定](AGENTS.md)。
