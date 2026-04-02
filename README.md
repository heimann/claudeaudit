# claudeaudit

Audit your repository for AI agent readiness.

14 categories, two dimensions (config readiness + ergonomics), concrete fixes.

## Install

```
npx skills add heimann/claudeaudit
```

Or tell any agent: `fetch claudeaudit.dev/SKILL.md and run it against this repo`

## What it produces

A compact scorecard with your top fixes ordered by impact:

```
claudeaudit - myapp

Good (worktree blocks Great)

  docs 2  structure 3  bootstrap 3  tests 2  perms 2  hooks 3  rules 2  worktree 1  sandbox 2
  feedback 2  errors 1  types 2  determinism 2  locality 2

Top fixes:
1. Make PORT configurable via env var in config/dev.exs -> worktree 1->2, unlocks Great
2. Add --formatter for concise test output -> errors 1->2
3. Add sub-module CLAUDE.md for lib/billing -> docs 2->3
```

After the report, it offers to fix the gaps step by step.

## Deterministic signal gathering

The skill includes a bash script (`skill/scripts/gather-signals.sh`) that reads all agent-readiness files deterministically - same output every run for the same repo state. This is used for the [Agent Readiness Index](https://github.com/heimann/claudeaudit-site) where we need reproducible scores across 100+ repos.

To run it manually:

```bash
bash skill/scripts/gather-signals.sh /path/to/repo
```

The output is a structured text report of every file that matters for scoring. You can pipe this to an LLM for scoring, or use the index runner in [claudeaudit-site](https://github.com/heimann/claudeaudit-site).

## License

MIT
