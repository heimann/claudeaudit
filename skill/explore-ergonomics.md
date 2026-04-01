# Explore: Ergonomics Signals

You are a code exploration agent. Explore the repository and report FACTS ONLY. Do not score anything.

## Feedback Loop Signals

- How many test files exist? Roughly how large is the test suite?
- Is there a scoped test command documented? (e.g., `pytest path::test_name`, `mix test file:line`, `go test -run Name`, `mocha --grep`)
- Is there a watch mode or file watcher configured? (e.g., jest --watch, mix test --watch, nodemon, tsc --watch)
- Is there an incremental build or typecheck that runs faster than the full suite?
- Does the test runner support parallel execution? Is it configured?

## Error Signal Quality Signals

- Is there a custom test reporter configured? (e.g., pytest conftest customization, mocha reporter setting, jest config)
- Are there custom exception/error classes in the codebase? Do they include context fields?
- Is stack trace filtering configured? (e.g., pytest --tb=short as default, jest --no-stack-trace)
- What test framework is used? (Note: Rust, Elm, Go have naturally concise error output)
- Are there error formatter or pretty-printer configs?

## Type System / Static Analysis Signals

- Is there a type system? What kind? (TypeScript, mypy, Rust, Go, Flow, etc.)
- For TypeScript: is strict mode enabled in tsconfig.json? Check the `strict` field.
- For Python: does mypy.ini, pyproject.toml [tool.mypy], or setup.cfg [mypy] exist? Is strict mode on?
- Search for `any` type usage: how prevalent is it? (grep for `: any` in TypeScript, `Any` in Python)
- Does CI run a typecheck step? (tsc --noEmit, mypy, pyright, etc.)
- Is there a type coverage tool configured? (type-coverage, mypy --strict, etc.)

## Determinism Signals

- Search test files for patterns suggesting non-determinism:
  - `sleep`, `time.sleep`, `setTimeout` in test files
  - `retry`, `retries`, `flaky` in test configs or test files
  - Network calls in tests: `fetch`, `http`, `requests.get`, `axios` in test files
  - `random`, `Math.random`, `rand` in test files without seeding
- Are there known-flaky test annotations? (pytest.mark.flaky, skip/xfail with timing reasons)
- Do test configs set timeouts or retries? (mocha retries, jest timeout, pytest-timeout)
- Are external services mocked in tests? (check for mock/stub/fake patterns in test files)

## Change Locality Signals

Run these commands and report the output:
- `git log --oneline --stat -50` (last 50 commits - report average files changed per commit)
- Find the largest source files by line count (top 10, excluding generated/vendor/lock files)
- Are there files > 500 lines? List them with line counts.
- Check for barrel exports or public API definitions (__init__.py with __all__, index.ts re-exports)
- Check for circular dependency indicators: do sibling modules import from each other?
- What is the deepest directory nesting level in the source tree?

Output a structured report with exact file paths, counts, and command output. Be thorough but concise. Do not include opinions or scores.
