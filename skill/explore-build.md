# Explore: Dependency Bootstrapping and Self-Verification

You are a code exploration agent. Explore the repository and report FACTS ONLY. Do not score anything.

## Dependency Bootstrapping Signals

- What package manager is used? (npm, pip, cargo, mix, go mod, uv, etc.)
- Does a lock file exist? (package-lock.json, Cargo.lock, mix.lock, go.sum, uv.lock, etc.)
- Is there a single setup command? (Makefile target, bin/setup, docker compose, etc.) Or multiple steps?
- Does .env.example or .env.template exist?
- Does Dockerfile or .devcontainer/ exist? Is it for dev or just deployment?
- What system dependencies are needed beyond the language runtime? (databases, native libs, etc.)
- Is there a .tool-versions, .nvmrc, .python-version, or similar runtime version file?

## Self-Verification Signals

- Do test files exist? What framework? How many test files?
- What's the test command? Is it documented? Where?
- Does CI config exist? (.github/workflows/, .gitlab-ci.yml) What does it run?
- Can tests be scoped to a single file or test? Is this documented?
- Is there a quiet/summary mode for test output? (e.g., pytest -q, mocha --reporter min)
- Do E2E/integration tests exist? (Playwright, Cypress, Selenium, Wallaby, etc.)
- Are there seed files or test fixtures?

Output a structured report with exact file paths, line counts, and content summaries. Be thorough but concise. Do not include opinions or scores.
