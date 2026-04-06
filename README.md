# claudeaudit

Audit your repository for AI agent readiness. How well can Claude Code or any coding agent understand, run, verify, and scale across your codebase?

14 categories across two dimensions. Concrete scores, actionable recommendations.

## Install

```bash
npx skills add heimann/claudeaudit
```

Then ask your agent to run `claudeaudit` on the current repo.

## Or just tell your agent

No install needed. Paste this into any AI coding agent:

```text
fetch https://claudeaudit.dev/SKILL.md and run it against this repo
```

Works with Claude Code, Codex, Cursor, and anything that can fetch a URL and follow instructions.

## What it checks

Two independent dimensions:

### Config readiness

How well the repo is set up for agents. You configure this once.

- Readable: agent documentation, repository structure
- Runnable: dependency bootstrapping, self-verification
- Safe: permissions, code quality hooks, rules and conventions
- Scalable: worktree readiness, sandbox compatibility

Maturity level = highest level where all categories in each cumulative tier score at least 2.

### Ergonomics

How pleasant and productive the repo is for agents to work in.

- Feedback loop
- Error signal quality
- Type system
- Determinism
- Change locality

## Example output

```text
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
```

Each category below 3 gets a finding and a concrete next step.

## How it works

The current scoring pipeline is deterministic signal gathering plus model-based scoring.

For interactive audits, the skill runs directly in the agent.
For bulk scoring and the 100-repo index, the site/index/eval tooling lives in the separate `heimann/claudeaudit-site` repo.

## Development

This repo is the skill source.

Tracked files:

```text
SKILL.md
scripts/gather-signals.sh
README.md
CLAUDE.md
```

## License

MIT
