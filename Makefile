supported_agents := codex claude gemini agy opencode copilot
path.codex    := .codex/AGENTS.md
path.claude   := .claude/CLAUDE.md
path.gemini   := .gemini/GEMINI.md
path.agy      := $(path.gemini)
path.opencode := .config/opencode/AGENTS.md
path.copilot  := .copilot/copilot-instructions.md

commands := install link help
.PHONY: $(commands)
.NOTPARALLEL:

# Make 把命令行中的每个名称都视为目标，调用 link 时先校验整批 agent。
ifneq ($(filter link,$(MAKECMDGOALS)),)
link_agents := $(filter-out $(commands),$(MAKECMDGOALS))
ifeq ($(link_agents),)
$(error 请指定 agent，例如 make link codex claude。支持 $(supported_agents))
endif
unknown_agents := $(filter-out $(supported_agents),$(link_agents))
ifneq ($(unknown_agents),)
$(error 未知 agent：$(unknown_agents)。支持 $(supported_agents))
endif

.PHONY: $(supported_agents)
$(supported_agents): ; @:
endif

install: SKILL.md
	@mkdir -p "$${HOME:?}/.agents"
	@if [ -d "$$HOME/.agents/AGENTS.md" ]; then echo "安装目标是目录：$$HOME/.agents/AGENTS.md" >&2; exit 1; fi
	@install -m 600 SKILL.md "$$HOME/.agents/AGENTS.md"
	@printf '已安装 %s\n' "$$HOME/.agents/AGENTS.md"

help:
	@printf '%s\n' \
		'make help               显示此帮助' \
		'make install            将 SKILL.md 复制到 ~/.agents/AGENTS.md，覆盖已有文件' \
		'make link codex claude  安装后为所选 agent 创建软链接，跳过已有目标' \
		'' \
		'link 后可指定一个或多个 agent 名称，用空格分隔。' \
		'支持的 agent 有 $(supported_agents)'

link:
	@set -eu; \
	source_file="$${HOME:?}/.agents/AGENTS.md"; \
	if [ ! -f "$$source_file" ]; then \
		printf '缺少 %s，请先运行 make install\n' "$$source_file" >&2; \
		exit 1; \
	fi; \
	for path in $(foreach agent,$(link_agents),$(path.$(agent))); do \
		target="$$HOME/$$path"; \
		if [ ! -e "$$target" ] && [ ! -L "$$target" ]; then \
			mkdir -p "$${target%/*}"; \
			if ln -s "$$source_file" "$$target"; then \
				printf '已链接 %s -> %s\n' "$$target" "$$source_file"; \
				continue; \
			fi; \
			[ -e "$$target" ] || [ -L "$$target" ] || exit 1; \
		fi; \
		printf '已跳过 %s\n' "$$target"; \
	done
