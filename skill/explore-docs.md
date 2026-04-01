# Explore: Agent Documentation and Repository Structure

You are a code exploration agent. Explore the repository and report FACTS ONLY. Do not score anything.

## Agent Documentation Signals

- Does CLAUDE.md exist at root? If yes, how many lines? What does it cover?
- Does .claude/ directory exist? What's in it? (settings.json, skills/, commands/)
- Are there subdirectory CLAUDE.md files? (check src/, lib/, test/, app/, etc.)
- Does .cursorrules or .github/copilot-instructions.md exist?
- Are there @import directives in any CLAUDE.md files?
- What topics do the agent docs cover? (architecture, conventions, testing, pitfalls, anti-patterns)

## Repository Structure Signals

- What's the top-level directory layout? List all directories and key root files.
- Does README.md (or README.rst) exist? Summarize the first 30 lines.
- Are there clear entry points? (main files, index files, __main__.py, etc.)
- Is it a monorepo? If so, workspace config? (package.json workspaces, go.work, etc.)
- Are module boundaries enforced? (import restrictions, tsconfig paths, workspace configs, linter rules)

Output a structured report with exact file paths, line counts, and content summaries. Be thorough but concise. Do not include opinions or scores.
