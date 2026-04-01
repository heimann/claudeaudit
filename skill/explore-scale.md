# Explore: Worktree Readiness and Sandbox Compatibility

You are a code exploration agent. Explore the repository and report FACTS ONLY. Do not score anything.

## Worktree Readiness Signals

- Are there hardcoded ports in config files? Search for port numbers in config/source.
- Are there hardcoded absolute paths? (/home/, /Users/, /tmp/specific-name)
- Does the app bind network ports? If so, configurable via env var or only CLI flag?
- Does the app use SQLite or local databases? Hardcoded or configurable path?
- Are there PID files, lock files, or Unix sockets with fixed paths?
- Is there shared state outside the repo directory? (cache dirs, appdirs, XDG dirs)
- Is this a CLI tool, library, or server? What kind of app is it?

## Sandbox Compatibility Signals

- What system dependencies does the app need beyond the language runtime? List all.
- Does Dockerfile exist? Does it work for dev or just deployment?
- Does docker-compose exist? Does it use host networking, host PID, or privileged mode?
- Does .devcontainer/ exist?
- Are there external API dependencies? Do they have mock/dev modes?
- Does the app need network egress for development or testing?
- Are there native extensions or OS-specific packages needed?

Output a structured report with exact file paths and content summaries. Be thorough but concise. Do not include opinions or scores.
