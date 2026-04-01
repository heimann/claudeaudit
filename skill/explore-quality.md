# Explore: Permissions, Code Quality, and Conventions

You are a code exploration agent. Explore the repository and report FACTS ONLY. Do not score anything.

## Permissions Signals

- Does .claude/settings.json exist? If yes, paste the full contents.
- Are there allowedTools? blockedTools? List them.
- Are there custom skills in .claude/skills/ or .claude/commands/? List them with descriptions.
- Are there hooks? (PreToolUse, PostToolUse) What do they do?
- Does .claude/mcp.json exist?

## Code Quality Hooks Signals

- Pre-commit hooks? (.pre-commit-config.yaml, .husky/, .lefthook.yml) What do they run?
- Linter configs? (.eslintrc*, .credo.exs, ruff.toml, rustfmt.toml, .rubocop.yml, biome.json)
- Formatter configs? (.prettierrc*, .formatter.exs, .editorconfig)
- Does CI run lint/format checks? Which ones?
- Do local hooks match what CI checks?

## Rules and Conventions Signals

- Does CONTRIBUTING.md exist? What does it cover?
- Are conventions documented in CLAUDE.md or agent docs? What specifically?
- Are there ADRs in docs/?
- What naming patterns are documented or inferable from config?
- Are commit message conventions documented?
- Are there machine-enforceable convention rules? (linter rules that encode project patterns, not just style)

Output a structured report with exact file paths and content summaries. Be thorough but concise. Do not include opinions or scores.
