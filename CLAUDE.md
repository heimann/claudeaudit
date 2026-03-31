# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

claudeaudit is an npm CLI that installs a Claude Code skill for auditing repositories' AI agent readiness. The CLI (`bin/cli.mjs`) copies `skill/SKILL.md` into the target repo's `.claude/skills/claudeaudit/` directory. Not yet published to npm.

## Architecture

- `bin/cli.mjs` - CLI entry point, copies skill into target repo
- `skill/SKILL.md` - the audit skill (copied by CLI at install time)
- `SKILL.md` (root) - source of truth for the skill; `skill/SKILL.md` must be kept in sync with this file
- `site/index.html` - static website for claudeaudit.dev

## Conventions

- Zero dependencies: the CLI uses only Node.js built-ins (`fs`, `path`, `url`). Do not add npm dependencies.
- ES modules (`.mjs` extension, `import` syntax)
