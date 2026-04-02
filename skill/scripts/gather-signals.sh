#!/usr/bin/env bash
# Deterministic signal gathering for claudeaudit
# Reads all files relevant to AI agent readiness and outputs a structured report.
# The LLM scores from this output - no exploration needed.
set -euo pipefail

REPO="${1:-.}"
cd "$REPO"

echo "=== CLAUDEAUDIT SIGNALS ==="
echo "repo_root: $(pwd)"
echo ""

# --- Agent Documentation ---
echo "## Agent Documentation"
for f in CLAUDE.md AGENTS.md .claude/CLAUDE.md .claude/settings.json .cursorrules .github/copilot-instructions.md; do
  if [ -f "$f" ]; then
    lines=$(wc -l < "$f")
    echo "FILE: $f ($lines lines)"
    head -100 "$f"
    echo "---END---"
  else
    echo "FILE: $f DOES NOT EXIST"
  fi
done

# Recursive CLAUDE.md and AGENTS.md
echo ""
echo "### Subdirectory agent docs"
find . -name "CLAUDE.md" -o -name "AGENTS.md" | grep -v node_modules | grep -v vendor | grep -v '.git/' | sort | while read -r f; do
  rel="${f#./}"
  # Skip root-level ones we already read
  case "$rel" in CLAUDE.md|AGENTS.md|.claude/CLAUDE.md) continue ;; esac
  lines=$(wc -l < "$f")
  echo "FILE: $rel ($lines lines)"
  head -50 "$f"
  echo "---END---"
done

# .claude/ and .agents/ directories
for d in .claude .agents; do
  if [ -d "$d" ]; then
    echo ""
    echo "### $d/ contents"
    find "$d" -type f | grep -v node_modules | sort | while read -r f; do
      # Skip files we already read
      case "$f" in .claude/CLAUDE.md|.claude/settings.json) continue ;; esac
      lines=$(wc -l < "$f")
      echo "FILE: $f ($lines lines)"
      head -50 "$f"
      echo "---END---"
    done
  fi
done

# --- Repository Structure ---
echo ""
echo "## Repository Structure"
echo "### Top-level layout"
ls -1
echo ""
echo "### README"
for f in README.md README.rst; do
  if [ -f "$f" ]; then
    echo "FILE: $f"
    head -30 "$f"
    echo "---END---"
    break
  fi
done

# --- Dependencies ---
echo ""
echo "## Dependencies"
for f in package.json pyproject.toml go.mod Cargo.toml mix.exs pubspec.yaml; do
  if [ -f "$f" ]; then
    echo "FILE: $f"
    head -40 "$f"
    echo "---END---"
    break
  fi
done

echo "### Lock files"
for f in package-lock.json pnpm-lock.yaml yarn.lock go.sum Cargo.lock uv.lock mix.lock pubspec.lock poetry.lock; do
  [ -f "$f" ] && echo "$f: EXISTS" || true
done

echo "### Setup"
for f in Makefile Justfile; do
  if [ -f "$f" ]; then
    echo "FILE: $f (first 30 lines)"
    head -30 "$f"
    echo "---END---"
    break
  fi
done
[ -f ".devcontainer/devcontainer.json" ] && echo ".devcontainer: EXISTS" || echo ".devcontainer: DOES NOT EXIST"
[ -f "Dockerfile" ] && echo "Dockerfile: EXISTS" || echo "Dockerfile: DOES NOT EXIST"
for f in .tool-versions .nvmrc .python-version .node-version; do
  [ -f "$f" ] && echo "$f: $(cat "$f")" || true
done

# --- Tests ---
echo ""
echo "## Tests"
test_count=$(find . -name "*.test.*" -o -name "*_test.*" -o -name "test_*.*" -o -name "*.spec.*" 2>/dev/null | grep -v node_modules | grep -v vendor | grep -v '.git/' | wc -l)
echo "test_file_count: $test_count"

if [ -d ".github/workflows" ]; then
  wf_count=$(ls .github/workflows/*.yml .github/workflows/*.yaml 2>/dev/null | wc -l)
  echo "ci_workflow_count: $wf_count"
  ls .github/workflows/ 2>/dev/null | head -10
else
  echo "ci: DOES NOT EXIST"
fi

# --- Code Quality ---
echo ""
echo "## Code Quality"
for f in .pre-commit-config.yaml .husky/pre-commit .lefthook.yml; do
  if [ -f "$f" ]; then
    echo "FILE: $f"
    head -40 "$f"
    echo "---END---"
  else
    echo "$f: DOES NOT EXIST"
  fi
done

echo "### Linter/formatter configs"
for f in .eslintrc.json .eslintrc.js eslint.config.js eslint.config.mjs .prettierrc .prettierrc.json biome.json biome.jsonc ruff.toml .golangci.yaml .golangci.yml rustfmt.toml .editorconfig; do
  [ -f "$f" ] && echo "$f: EXISTS" || true
done

# --- Conventions ---
echo ""
echo "## Conventions"
if [ -f "CONTRIBUTING.md" ]; then
  lines=$(wc -l < CONTRIBUTING.md)
  echo "CONTRIBUTING.md: $lines lines"
  head -20 CONTRIBUTING.md
  echo "---END---"
else
  echo "CONTRIBUTING.md: DOES NOT EXIST"
fi

# --- Scalability ---
echo ""
echo "## Scalability"
# Check for port configuration
grep -rn "PORT\|port" *.json *.toml *.yaml *.yml *.exs 2>/dev/null | grep -i "env\|environ\|getenv\|system.get_env\|os.environ\|process.env" | head -5 || echo "no env-based port config found"
# App type heuristic
if [ -f "package.json" ] && grep -q '"bin"' package.json 2>/dev/null; then
  echo "app_type: CLI tool (has bin in package.json)"
elif [ -f "go.mod" ] && [ -f "main.go" ]; then
  echo "app_type: Go binary"
elif [ -f "setup.py" ] || [ -f "pyproject.toml" ]; then
  echo "app_type: Python package"
else
  echo "app_type: unknown"
fi

# --- Ergonomics ---
echo ""
echo "## Ergonomics"
# Watch mode
if [ -f "package.json" ]; then
  echo "### npm scripts with watch/dev"
  grep -E '"(watch|dev)"' package.json 2>/dev/null | head -5 || echo "no watch/dev scripts"
fi

# TypeScript strict
if [ -f "tsconfig.json" ]; then
  echo "### tsconfig.json"
  cat tsconfig.json | head -30
  echo "---END---"
fi

# Python mypy
if [ -f "pyproject.toml" ]; then
  echo "### mypy config"
  grep -A 5 "\[tool.mypy\]" pyproject.toml 2>/dev/null || echo "no [tool.mypy] section"
fi

# Sleep patterns in tests
echo "### Determinism"
sleep_count=$(grep -rn "sleep\|setTimeout" --include="*.test.*" --include="*_test.*" --include="test_*" . 2>/dev/null | grep -v node_modules | grep -v vendor | wc -l)
echo "sleep_pattern_count_in_tests: $sleep_count"

# Largest files
echo "### Largest source files"
find . -name "*.ts" -o -name "*.js" -o -name "*.py" -o -name "*.go" -o -name "*.rs" -o -name "*.ex" -o -name "*.rb" -o -name "*.java" -o -name "*.dart" -o -name "*.swift" -o -name "*.c" -o -name "*.cpp" 2>/dev/null \
  | grep -v node_modules | grep -v vendor | grep -v dist | grep -v build | grep -v '.git/' | grep -v '.next' \
  | head -1000 | xargs wc -l 2>/dev/null | sort -rn | head -11

echo ""
echo "=== END SIGNALS ==="
