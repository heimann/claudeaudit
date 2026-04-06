# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project

claudeaudit is an installable agent skill for auditing repositories' AI agent readiness.

Distribution is via `npx skills add heimann/claudeaudit` or by fetching `https://claudeaudit.dev/SKILL.md` directly.

This repo is not meant to ship a standalone npm CLI.

## Architecture

- `SKILL.md` - root source of truth for the skill
- `scripts/gather-signals.sh` - deterministic signal-gathering helper used by the skill

The site, evals, and 100-repo index live in the separate `heimann/claudeaudit-site` repo.

## Conventions

- Keep a single root `SKILL.md`
- Keep helper scripts under `scripts/`
- Prefer the skill/install distribution story over package/CLI distribution
- Do not add npm dependencies unless we explicitly decide to reintroduce package-based distribution
