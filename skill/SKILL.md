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
| 2 | CLAUDE.md covers project purpose, architecture, conventions, and how to run/test - agent can orient itself without reading every source file. Or equivalent in .cursorrules / .github/copilot-instructions.md. A single @import to a comprehensive file (e.g., AGENTS.md) counts if that file covers the same ground |
| 3 | Multi-level agent docs: root CLAUDE.md plus sub-module documentation (subdirectory CLAUDE.md files, or @imports that pull in module-specific guidance). Docs cover not just what to do but what NOT to do (anti-patterns, decision rationale). Score 3 requires depth across the codebase, not just one thorough top-level file |

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
| 2 | Agent can find entry points and module boundaries without guessing. README or docs explain the layout, not just list it |
| 3 | Module boundaries are enforced, not just documented (workspace configs, import restrictions, clear package boundaries). Entry points are obvious from structure alone |

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
| 2 | A single documented command gets the agent from clone to running/testable (e.g., `mix setup`, `make dev`, `docker compose up`). Lock files present. System deps documented or containerized. If env vars are needed, `.env.example` or `.env.template` exists |
| 3 | Truly zero-friction: one command, no prerequisites beyond a language runtime or Docker. Devcontainer or Docker config means the agent doesn't even need the right language version installed. Seed data included if applicable. No manual env var setup required. Two-step processes (e.g., "install tool X then run make dev") are a 2, not a 3 |

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
| 1 | Unit tests exist, pass, and the agent knows which command to run (documented or inferable from manifest) |
| 2 | Tests cover critical paths and catch real regressions, not just token coverage. Test database seeds automatically. CI config shows canonical test commands. Agent can run the full suite without manual intervention |
| 3 | All of score 2, plus: agent can run scoped tests (single file or module) for fast feedback. Test output is agent-friendly (quiet/summary mode available or output is concise by default). E2E or integration tests exist for critical user flows, not just unit tests. Seed data available if applicable |

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
| 2 | `allowedTools` scoped to what the agent needs: test commands, build tools, linters are pre-approved. Dangerous operations are not in the allow list |
| 3 | All of score 2, plus at least two of: (a) explicit `blockedTools` for dangerous operations, (b) custom skills or hooks for project workflows, (c) MCP servers configured, (d) tool access documented in CLAUDE.md. Permissions show intentional design, not just a basic allow list |

Signals to check:
- `.claude/settings.json` at repo root
- `allowedTools` present with specific command patterns (not overly broad like `Bash(*)`)
- `blockedTools` for dangerous operations (force push, rm -rf, publish)
- Custom skills in `.claude/skills/` or hooks in settings
- Whether test/build/lint commands are pre-approved
- MCP server configs (`.claude/mcp.json` or similar)
- Tool access documented in CLAUDE.md

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
| 0 | No documented conventions in prose or agent-oriented docs. Linter/formatter config files alone do not count - they enforce style but don't tell the agent about project-specific patterns, naming, architecture decisions, or workflow expectations |
| 1 | Basic conventions mentioned in README, CONTRIBUTING.md, or similar (e.g., "we use Tailwind", "commits should be conventional"). Or: conventions are inferable from well-configured linter/formatter/editorconfig files, but not explained in prose |
| 2 | Conventions are specific enough to follow without seeing examples: naming patterns, error handling approach, testing expectations. In CLAUDE.md or well-structured docs |
| 3 | Conventions are machine-enforceable where possible (linter rules, not just prose). Rules reference WHY, not just WHAT. Covers commit format, PR conventions, module boundaries, error handling, test structure |

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
Score based on **actual collision risk**, not just configuration presence. A stateless CLI tool or pure library has no collision surface and should score well without explicit worktree config.

| Score | Criteria |
|-------|----------|
| 0 | Hardcoded absolute paths, state written outside repo, port collisions likely. Multiple sessions WILL interfere |
| 1 | Relative paths used but shared state issues likely (single SQLite file, hardcoded ports with no override, shared tmp dirs). Multiple sessions MIGHT interfere |
| 2 | Either: (a) the app has no collision surface (stateless CLI, library, no ports, no local DB), or (b) ports and database URLs are configurable via env vars, no repo-external state. Could work in parallel worktrees with minor env tweaks |
| 3 | Explicitly designed for parallel sessions: ports derived from env var or worktree path, database per-worktree or per-session, no singleton resources. Or containerized so each session is isolated. Or: app is inherently stateless AND documents this fact for agent confidence |

Signals to check:
- Does the app bind ports? If yes, are they configurable via env var (not just CLI flag)?
- Does the app write local state (SQLite, PID files, lock files, Unix sockets)?
- Hardcoded absolute paths (`/home/`, `/Users/`, `/tmp/specific-name`)
- Shared cache directories (e.g., appdirs, XDG cache with fixed paths)
- For web apps: `PORT` env var support is the minimum bar
- Docker Compose with configurable service names/ports
- For stateless tools (CLI, library, build tool): inherently low-risk, score based on whether any shared state exists at all

#### 9. Sandbox compatibility (`/3`)

Can the agent build, test, and develop in a restricted environment (container, VM, CI runner) without host-specific resources?

Score based on **actual friction**, not container config presence. A trivially simple app with no system deps is inherently sandbox-compatible and should score well even without a Dockerfile.

| Score | Criteria |
|-------|----------|
| 0 | Dev workflow requires resources sandboxes typically cannot provide: GPU/display server, host network/PID namespace, specific OS services, or undocumented system packages with no install path |
| 1 | Dev workflow mostly works in a sandbox but has friction: needs system packages that are documented but not automated (e.g., "install FFmpeg"), or some features fail without host access. External API keys needed but not documented |
| 2 | Dev workflow runs in a sandbox with minimal setup. Either: (a) the app has few enough system deps that standard language runtimes suffice (e.g., pure Node.js, pure Python with no native extensions), or (b) a Dockerfile/devcontainer automates the heavier setup. External deps are optional or mockable. Network requirements documented |
| 3 | Explicitly sandbox-ready: Dockerfile or devcontainer tested in restricted environments, external deps stubbed for dev, no host resource assumptions. `.claude/settings.json` permissions pre-configured. Or: the app is trivially portable (no system deps, no network, no external services) AND documents this fact |

Signals to check:
- System dependency weight: does the app need only a language runtime, or also native packages, databases, display servers?
- `Dockerfile`, `docker-compose.yml`, `.devcontainer/` (important for heavy deps, less important for trivially portable apps)
- External service dependencies (APIs, databases, cloud services) and whether they have dev/mock modes
- Network egress requirements documented
- Whether the app actually runs in a fresh container or VM (not just "has a Dockerfile")
- `.claude/settings.json` configured for sandbox permissions

---

## Output format

Produce the audit as a structured report:

```
claudeaudit - {repo_name} - {date}

{Bad|Ok|Good|Great} - {level_name}

Readable
  Agent documentation  {s}/3    Repository structure  {s}/3

Runnable
  Dependency bootstrap {s}/3    Self-verification     {s}/3

Safe
  Permissions          {s}/3    Code quality hooks    {s}/3
  Rules & conventions  {s}/3

Scalable
  Worktree readiness   {s}/3    Sandbox compat.       {s}/3
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

1. Use the Glob tool to find files, the Read tool to read them, and the Grep tool to search contents. Prefer these over shell commands.
2. Read key files (CLAUDE.md, config files, CI config) to assess quality, not just presence
3. Score based on the rubric — be honest, not generous. A 2 is good. A 3 is exceptional.
4. Note specific files and lines that informed your score
5. Write concrete, actionable recommendations (not "improve documentation" but "add a CLAUDE.md section covering your Ecto schema naming convention")

Start by getting a high-level view of the repo:

1. **Agent docs and config** — use Glob to find agent-oriented files:
   - `**/CLAUDE.md`, `.claude/**`, `.cursorrules`, `.github/copilot-instructions.md`

2. **Build and setup** — use Glob to find build/setup configs:
   - `Makefile`, `Justfile`, `docker-compose*`, `Dockerfile`, `.devcontainer/**`

3. **Project overview** — use Read on `README.md` (first 50 lines) and any manifest files (`package.json`, `Cargo.toml`, `pyproject.toml`, `go.mod`, `mix.exs`)

4. **Code quality configs** — use Glob to find linter/formatter/hook configs:
   - `.pre-commit-config.yaml`, `.husky/**`, `.lefthook.yml`
   - `.eslintrc*`, `.prettierrc*`, `.credo.exs`, `.formatter.exs`, `ruff.toml`, `biome.json`

5. **Tests and CI** — use Glob to find test files and CI config:
   - `**/*test*`, `**/*spec*` (limit depth to 3)
   - `.github/workflows/**`, `.gitlab-ci.yml`

6. **Environment** — use Glob to find env templates and seed files:
   - `.env*`, `**/seeds*`, `**/seed*`

7. **Permissions** — use Read on `.claude/settings.json` if it exists

Then dive deeper into each category as needed. Read files, don't just check existence.

---

## For website delivery (claudeaudit.dev)

If you're reading this from a URL rather than as an installed skill, everything above still applies. Treat this document as your instructions and run the audit against whatever repository you're currently working in.

The user may say something like "run claudeaudit.dev" or "audit this repo with claudeaudit" — in both cases, follow the process above.
