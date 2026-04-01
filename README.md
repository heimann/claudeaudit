# claudeaudit

Audit your repository for AI agent readiness. How well can Claude Code (or any coding agent) understand, run, verify, and scale across your codebase?

14 categories across two dimensions. Concrete scores, actionable recommendations.

## Install

```
npx claudeaudit
```

This copies the audit skill into `.claude/skills/claudeaudit/` in your project. Next time you ask Claude Code to audit the repo, it will use the skill automatically.

## Or just tell your agent

No install needed. Paste this into any AI coding agent:

```
fetch https://claudeaudit.dev/SKILL.md and run it against this repo
```

Works with Claude Code, Codex, Cursor, and anything that can fetch a URL and follow instructions.

## What it checks

Two independent dimensions:

### Config readiness (maturity level: Bad / Ok / Good / Great)

How well the repo is *set up* for agents. You configure this once.

| Level | Tier | Categories |
|-------|------|------------|
| Bad | Readable | Agent documentation, Repository structure |
| Ok | Runnable | Dependency bootstrapping, Self-verification |
| Good | Safe | Permissions, Code quality hooks, Rules & conventions |
| Great | Scalable | Worktree readiness, Sandbox compatibility |

Maturity level = highest level where all categories (cumulative) score >= 2.

### Ergonomics (flat scores, no level)

How *pleasant and productive* the repo is for agents to work in. This improves continuously.

| Category | What it measures |
|----------|-----------------|
| Feedback loop | Can the agent verify a change fast? Scoped tests, watch mode |
| Error signal quality | Are errors concise and actionable, or noisy stack traces? |
| Type system | Does static analysis catch mistakes before runtime? |
| Determinism | Same command, same result? No flaky tests, no network in tests |
| Change locality | Can the agent change one thing without reading everything? |

## Example output

```
claudeaudit - myapp - 2026-04-01

Good - Safe

Readable
  Agent documentation  2/3    Repository structure  3/3

Runnable
  Dependency bootstrap 3/3    Self-verification     2/3

Safe
  Permissions          2/3    Code quality hooks    3/3
  Rules & conventions  2/3

Scalable
  Worktree readiness   1/3    Sandbox compat.       2/3

Ergonomics
  Feedback loop        2/3    Error signal quality  1/3
  Type system          2/3    Determinism           2/3
  Change locality      2/3

Worktree readiness 1/3
  Port 4000 hardcoded in config/dev.exs with no env var override.
  -> Read PORT from System.get_env("PORT", "4000") in config/runtime.exs.

Self-verification 2/3
  Tests exist and pass, CI runs them. No scoped test command documented.
  -> Add to CLAUDE.md: "mix test test/myapp/billing_test.exs:42"

Error signal quality 1/3
  Default Phoenix error output. No custom error formatters.
  -> Add --formatter Elixir.CLI.Formatter to .formatter.exs for concise test output.
```

Each category below 3 gets a finding and a concrete next step.

## How it works

The skill uses a two-phase hybrid approach:

1. **Explore** - 5 parallel agents (haiku) scan the repo for signals: files, configs, git metadata, test patterns, file sizes
2. **Score** - One agent (opus) reads the signal data and scores against the rubric

This produces stable, accurate results. In stability testing (5 runs per repo, 4 fixture repos), config readiness scores are 97% stable and ergonomics scores are 100% stable across runs.

Falls back to single-agent mode if subagents are unavailable.

## Scoring philosophy

- Be honest, not generous. A 2 is good. A 3 is exceptional.
- Score based on what exists, not what could exist.
- Recommendations must be concrete and copy-pasteable into a task list.
- "Add a CLAUDE.md section covering your Ecto schema naming convention" not "improve documentation."

## Development

```
git clone https://github.com/heimann/claudeaudit
cd claudeaudit
```

Zero dependencies. The CLI uses only Node.js built-ins.

### Structure

```
bin/cli.mjs          CLI entry point (copies skill into target repo)
skill/SKILL.md       Main audit skill (source of truth)
skill/explore-*.md   Haiku exploration prompts (5 files)
SKILL.md             Root copy (kept in sync with skill/SKILL.md)
site/index.html      claudeaudit.dev static site
evals/               Stability test fixtures and results
```

### Running evals

```bash
./evals/setup_fixtures.sh    # clone fixture repos at pinned SHAs
```

Then dispatch haiku exploration agents + opus scoring agents per the eval methodology in `evals/*.md`.

## License

MIT
