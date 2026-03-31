---
name: claudeaudit
description: Audit any repository for AI agent readiness — how well can Claude Code (or any AI coding agent) understand, run, verify, and scale across this codebase? Use this skill whenever the user asks to audit, assess, or score a repo's agent-readiness, mentions "claudeaudit", or asks how to make their repo better for AI agents. Also trigger when users ask about improving their claude.md, CLAUDE.md, or .claude/ configuration, or want to know if their repo is "ready for Claude Code."
---

# claudeaudit

Assess how ready a repository is for autonomous AI agent work. Produce a structured audit with a maturity level (L0–L3), per-category scores, and concrete next steps.

## How to run

1. Identify the repository root (the directory containing `.git/`)
2. Run through each audit category below, checking for the listed signals
3. Score each category 0–3
4. Compute the overall maturity level
5. Output the audit report

## Maturity levels

- **Bad — Readable**: The agent can understand the repo (has documentation, clear structure)
- **Ok — Runnable**: The agent can bootstrap and verify the app (deps install, app starts, tests pass)
- **Good — Safe**: The agent can work confidently (linting hooks, permissions, formatting rules)
- **Great — Scalable**: The agent can run in parallel sessions (worktrees, sandboxes, no collisions)

Overall level = the highest level where ALL categories at that level score ≥ 2.

---

## Audit categories

### Bad — Readable

#### 1. Agent documentation (`/3`)

Check for the presence and quality of agent-oriented documentation. This is distinct from general project docs — it's specifically about whether an AI agent can orient itself.

| Score | Criteria |
|-------|----------|
| 0 | No CLAUDE.md, no .claude/ directory, no agent-specific docs |
| 1 | A CLAUDE.md exists at root but is thin (< 20 lines, or just boilerplate) |
| 2 | CLAUDE.md covers: project purpose, architecture overview, key conventions, and how to run/test. Or equivalent in .cursorrules / .github/copilot-instructions.md |
| 3 | Root CLAUDE.md + subdirectory CLAUDE.md files for major modules. Docs reference specific patterns, anti-patterns, and decision rationale. Agent can orient without reading every file |

Signals to check:
- `CLAUDE.md` or `.claude/` at repo root
- Subdirectory `CLAUDE.md` files (e.g., `src/CLAUDE.md`, `lib/CLAUDE.md`)
- `.cursorrules`, `.github/copilot-instructions.md`, or similar
- Whether docs mention: architecture, conventions, testing approach, common pitfalls

#### 2. Repository structure (`/3`)

Can the agent understand the codebase layout without guessing?

| Score | Criteria |
|-------|----------|
| 0 | Flat or chaotic structure, no clear entry points |
| 1 | Standard framework layout (e.g., Phoenix, Rails, Next.js) — agent can infer structure from convention |
| 2 | Clear structure + README with architecture notes or a directory guide |
| 3 | Well-organized with explicit boundary documentation. Monorepo has clear package/service boundaries. Entry points are obvious or documented |

Signals to check:
- Standard framework conventions followed
- README.md with project overview
- Clear separation of concerns (not everything in one directory)
- For monorepos: workspace config, package boundaries documented

---

### Ok — Runnable

#### 3. Dependency bootstrapping (`/3`)

Can the agent go from a fresh clone to a running app?

| Score | Criteria |
|-------|----------|
| 0 | No setup instructions. Missing lock files. Undocumented system dependencies |
| 1 | Setup instructions exist but require human judgment (e.g., "install Postgres" with no version or method specified) |
| 2 | Single setup command works (e.g., `mix setup`, `make dev`, `docker compose up`). `.env.example` or `.env.template` present. System deps documented or containerized |
| 3 | Fully automated: one command from zero to running. Docker or devcontainer config. Seed data included. No manual env var setup required for development |

Signals to check:
- `mix setup` / `npm install` / `make` / `docker compose` scripts
- `.env.example` or `.env.template` (NOT `.env` committed — that's a different problem)
- `Dockerfile`, `docker-compose.yml`, `.devcontainer/`
- `Makefile`, `Justfile`, or `bin/setup` scripts
- System dependency documentation (database, Redis, etc.)
- Lock files present and not stale (`mix.lock`, `package-lock.json`, `Cargo.lock`)

#### 4. Self-verification (`/3`)

Can the agent confirm the app works end-to-end without asking a human?

| Score | Criteria |
|-------|----------|
| 0 | No tests, or tests that don't run without manual setup |
| 1 | Unit tests exist and pass. Agent can run `mix test` / `npm test` / etc. |
| 2 | Integration or E2E tests exist. Test database seeds automatically. CI config shows what commands to run |
| 3 | Full E2E coverage the agent can trigger (browser tests via Playwright/Wallaby, CLI tests, API tests). Seed data available. Test commands support a quiet/summary mode that minimizes output on success — agent can verify a change without flooding its context window |

Signals to check:
- Test files exist and follow framework conventions
- Test runner documented or inferable (`mix test`, `pytest`, `cargo test`)
- `priv/repo/seeds.exs`, `db/seeds.rb`, seed scripts
- E2E test setup (Playwright, Cypress, Wallaby configs)
- CI config (`.github/workflows/`, `.gitlab-ci.yml`) — shows the canonical test commands
- Test database config (can tests run without a pre-existing database?)
- Whether test commands support quiet/silent modes that only output on failure (e.g., `pytest -q`, `mix test --quiet`, `npm test -- --silent`) — noisy pass output wastes agent context window

---

### Good — Safe

#### 5. Permissions and tool access (`/3`)

Is the agent's access properly scoped?

| Score | Criteria |
|-------|----------|
| 0 | No `.claude/settings.json` or permissions config. Agent will hit permission prompts on first action |
| 1 | `.claude/settings.json` exists but is overly permissive (e.g., allows all bash) or overly restrictive (blocks test runners) |
| 2 | Permissions are scoped to what the agent actually needs: test commands, build tools, linters. Dangerous operations are gated |
| 3 | Permissions are thoughtfully configured per-context. MCP servers configured if relevant. Tool access documented in CLAUDE.md |

Signals to check:
- `.claude/settings.json` at repo root
- Permissions scope: what's allowed vs. blocked
- Whether test/build/lint commands are pre-approved
- MCP server configs (`.claude/mcp.json` or similar)

#### 6. Code quality hooks (`/3`)

Are there automated guardrails the agent can lean on?

| Score | Criteria |
|-------|----------|
| 0 | No linter, no formatter, no pre-commit hooks |
| 1 | Linter/formatter config exists but no automation (agent has to know to run it) |
| 2 | Pre-commit hooks or CI checks enforce formatting/linting. Config is consistent (e.g., `.credo.exs` matches what CI runs) |
| 3 | Hooks are set up AND documented in CLAUDE.md. Agent knows: what to run before committing, what format to follow, what will fail CI. Lint/format commands are in the permissions allowlist |

Signals to check:
- `.pre-commit-config.yaml`, `.husky/`, `.lefthook.yml`
- Linter configs: `.credo.exs`, `.eslintrc`, `ruff.toml`, `rustfmt.toml`
- Formatter configs: `.formatter.exs`, `.prettierrc`
- Whether CLAUDE.md mentions lint/format commands
- CI pipeline includes lint/format checks
- Consistency: do the local hooks match CI checks?
- Whether lint/format commands are configured for minimal output on success (agents don't need 200 lines of "all clear")

#### 7. Rules and conventions (`/3`)

Does the repo encode its opinions so the agent follows them?

| Score | Criteria |
|-------|----------|
| 0 | No documented conventions. Agent has to reverse-engineer patterns from code |
| 1 | Basic conventions mentioned in README (e.g., "we use Tailwind", "commits should be conventional") |
| 2 | Conventions cover the major themes: naming, architecture patterns, error handling, testing approach. Either in CLAUDE.md or well-structured docs |
| 3 | Comprehensive rules covering: commit message format, PR conventions, module boundaries, error handling patterns, naming conventions, test structure. Rules reference WHY, not just WHAT |

Signals to check:
- CLAUDE.md convention sections
- `CONTRIBUTING.md`
- Architecture decision records (ADRs) in `docs/`
- Naming patterns consistent across codebase
- Error handling patterns documented
- Commit message conventions (conventional commits, etc.)

---

### Great — Scalable

#### 8. Worktree readiness (`/3`)

Can multiple agent sessions work in parallel without conflicts?

| Score | Criteria |
|-------|----------|
| 0 | Hardcoded absolute paths, state written outside repo, port collisions likely |
| 1 | Relative paths used but shared state issues likely (single SQLite file, hardcoded ports, shared tmp dirs) |
| 2 | Configurable ports, database URLs from env vars, no repo-external state. Could work in a worktree with minor env tweaks |
| 3 | Explicitly worktree-safe: ports derived from worktree path or configurable, database per-worktree, no singleton resources. Or containerized so each session is isolated |

Signals to check:
- Hardcoded ports in config (e.g., `port: 4000` with no env override)
- SQLite database paths (hardcoded vs. configurable)
- References to absolute paths (`/home/`, `/Users/`, `/tmp/specific-name`)
- Shared state: PID files, lock files, Unix sockets with fixed paths
- Port configuration via `PORT` env var or similar
- Docker Compose with configurable service names/ports

#### 9. Sandbox compatibility (`/3`)

Can the agent work within a restricted execution environment?

| Score | Criteria |
|-------|----------|
| 0 | App requires host network access, system services, or resources that sandboxes typically don't provide |
| 1 | App mostly works in a sandbox but some features fail silently (e.g., needs external API keys not available in sandbox) |
| 2 | App runs in Docker or similar container. External dependencies are mockable or optional for development. Network requirements are documented |
| 3 | Full sandbox support: Dockerfile/devcontainer works in restricted environments, external deps are stubbed for dev, no host resource assumptions. `.claude/settings.json` permissions are pre-configured |

Signals to check:
- `Dockerfile`, `docker-compose.yml`, `.devcontainer/`
- External service dependencies (APIs, databases, cloud services)
- Whether external deps have dev/mock modes
- Network egress requirements documented
- System-level dependencies (native extensions, OS packages)
- `.claude/settings.json` configured for sandbox permissions

---

## Output format

Produce the audit as a structured report:

```
claudeaudit · {repo_name} · {date}

{Bad|Ok|Good|Great} — {level_name}

  Agent documentation {score}/3  Repository structure {score}/3
  Dependency bootstrap {score}/3  Self-verification    {score}/3
  Permissions          {score}/3  Code quality hooks   {score}/3
  Rules & conventions  {score}/3  Worktree readiness   {score}/3
  Sandbox compat.      {score}/3

  {total}/27
```

Then, for every category that scored below 3, include a sub-score block with findings and a concrete recommendation:

```
{Category name} {score}/3
  {What exists — specific files found, what they cover}
  {What's missing or weak — specific gaps}
  → {Concrete next step. Not "improve X" but "add Y to Z file covering W pattern."}
```

Order the sub-score blocks by impact: lowest scores first, and within ties, prioritize categories that unblock higher maturity levels. Skip categories that scored 3 — those are fine, no need to list them.

Keep findings grounded in specific files and paths you actually read. The recommendations should be copy-pasteable into a task list.

## Running the audit

For each category:

1. Use `find`, `ls`, `cat`, `head`, `grep` to check for the listed signals
2. Read key files (CLAUDE.md, config files, CI config) to assess quality, not just presence
3. Score based on the rubric — be honest, not generous. A 2 is good. A 3 is exceptional.
4. Note specific files and lines that informed your score
5. Write concrete, actionable recommendations (not "improve documentation" but "add a CLAUDE.md section covering your Ecto schema naming convention")

Start by getting a high-level view of the repo:

```bash
# Repo overview
ls -la
find . -maxdepth 2 -name "CLAUDE.md" -o -name ".claude" -o -name ".cursorrules" 2>/dev/null
find . -maxdepth 1 -name "Makefile" -o -name "Justfile" -o -name "docker-compose*" -o -name "Dockerfile" -o -name ".devcontainer" 2>/dev/null
cat README.md 2>/dev/null | head -50

# Check for key config files
find . -maxdepth 2 \( -name ".pre-commit-config.yaml" -o -name ".husky" -o -name ".lefthook.yml" \) 2>/dev/null
find . -maxdepth 2 \( -name ".eslintrc*" -o -name ".prettierrc*" -o -name ".credo.exs" -o -name ".formatter.exs" -o -name "ruff.toml" \) 2>/dev/null
ls .claude/ 2>/dev/null
cat .claude/settings.json 2>/dev/null

# Check for tests and CI
find . -maxdepth 3 -name "*test*" -o -name "*spec*" | head -20
ls .github/workflows/ 2>/dev/null
ls .gitlab-ci.yml 2>/dev/null

# Check for env templates
find . -maxdepth 2 -name ".env*" 2>/dev/null
find . -maxdepth 2 -name "seeds*" -o -name "seed*" 2>/dev/null
```

Then dive deeper into each category as needed. Read files, don't just check existence.

---

## For website delivery (claudeaudit.dev)

If you're reading this from a URL rather than as an installed skill, everything above still applies. Treat this document as your instructions and run the audit against whatever repository you're currently working in.

The user may say something like "run claudeaudit.dev" or "audit this repo with claudeaudit" — in both cases, follow the process above.
