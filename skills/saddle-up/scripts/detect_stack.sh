#!/usr/bin/env bash
# detect_stack.sh — deterministic repo reconnaissance for saddle-up.
# Usage: detect_stack.sh [repo-root]     (default: .)
# Output: grep-friendly "DETECT key=value" lines on stdout. Read-only.
set -u
ROOT="${1:-.}"
cd "$ROOT" 2>/dev/null || { echo "DETECT error=bad-root $ROOT"; exit 1; }

say() { echo "DETECT $1"; }
has() { [ -e "$1" ]; }

# --- ecosystems ---------------------------------------------------------------
ECO=""
has package.json     && ECO="$ECO node"
{ has pyproject.toml || has requirements.txt || has setup.py; } && ECO="$ECO python"
has go.mod           && ECO="$ECO go"
has Cargo.toml       && ECO="$ECO rust"
has pom.xml          && ECO="$ECO jvm-maven"
{ has build.gradle || has build.gradle.kts; } && ECO="$ECO jvm-gradle"
has Gemfile          && ECO="$ECO ruby"
has composer.json    && ECO="$ECO php"
has mix.exs          && ECO="$ECO elixir"
ls ./*.sln ./*.csproj 2>/dev/null | head -1 | grep -q . && ECO="$ECO dotnet"
ECO="${ECO# }"
say "ecosystems=${ECO:-none-detected}"

# --- package managers ----------------------------------------------------------
if has package.json; then
  PM="npm"
  { has bun.lockb || has bun.lock; } && PM="bun"
  has pnpm-lock.yaml && PM="pnpm"
  has yarn.lock && PM="yarn"
  has package-lock.json && say "node_lockfile=package-lock.json"
  say "node_pm=$PM"
fi
if has pyproject.toml || has requirements.txt || has setup.py; then
  PPM="pip"
  has uv.lock && PPM="uv"
  has poetry.lock && PPM="poetry"
  has Pipfile && PPM="pipenv"
  say "python_pm=$PPM"
fi

# --- monorepo signals ----------------------------------------------------------
MONO=""
has pnpm-workspace.yaml && MONO="$MONO pnpm-workspace"
has nx.json             && MONO="$MONO nx"
has turbo.json          && MONO="$MONO turbo"
has lerna.json          && MONO="$MONO lerna"
has go.work             && MONO="$MONO go-work"
has package.json && grep -q '"workspaces"' package.json 2>/dev/null && MONO="$MONO npm-workspaces"
has Cargo.toml && grep -q '^\[workspace\]' Cargo.toml 2>/dev/null && MONO="$MONO cargo-workspace"
[ -n "$MONO" ] && say "monorepo=$MONO" || say "monorepo=no"

# --- declared scripts / targets --------------------------------------------------
if has package.json; then
  if command -v node >/dev/null 2>&1; then
    node -e 'const s=require("./package.json").scripts||{};for(const k of Object.keys(s))console.log("DETECT npm_script="+k+" :: "+s[k])' 2>/dev/null
  else
    # No node on PATH: a grep fallback fabricates/mangles names — refuse.
    say "npm_scripts=unparsed-no-node (read package.json scripts manually)"
  fi
fi
if has package.json && command -v node >/dev/null 2>&1; then
  node -e '
const p=require("./package.json");const d={...(p.dependencies||{}),...(p.devDependencies||{})};
const fw=["react","react-dom","next","vue","nuxt","svelte","@sveltejs/kit","@angular/core","astro","@remix-run/react","express","fastify","@nestjs/core","vite","vitest","jest","@playwright/test","cypress","tailwindcss","typescript","storybook","electron"];
for(const f of fw) if(d[f]) console.log("DETECT dep="+f+"@"+d[f]);
console.log("DETECT runtime_dep_count="+Object.keys(p.dependencies||{}).length);
' 2>/dev/null
fi
if has pyproject.toml; then
  grep -oE '"?(django|flask|fastapi|pydantic|numpy|pandas|torch|sqlalchemy)[[>=<~^" ]' pyproject.toml 2>/dev/null | tr -d '">=<~^[ ' | sort -u | sed 's/^/DETECT dep=/'
fi
if has Makefile; then
  grep -E '^[a-zA-Z0-9_.-]+:([^=]|$)' Makefile 2>/dev/null | cut -d: -f1 | sort -u | head -30 | sed 's/^/DETECT make_target=/'
fi
if has pyproject.toml; then
  grep -qE '^\[tool\.(ruff|black|flake8)' pyproject.toml && say "python_lint=configured"
  grep -qE '^\[tool\.(mypy|pyright)' pyproject.toml && say "python_types=configured"
  grep -qE '^\[tool\.pytest' pyproject.toml && say "python_pytest=configured"
fi

# --- tests reality (counts, not claims) ------------------------------------------
TESTS=$(find . \( -name node_modules -o -name .git -o -name .venv -o -name venv \
  -o -name vendor -o -name dist -o -name build -o -name target -o -name __pycache__ \) -prune -o -type f \
  \( -name "*.test.*" -o -name "*_test.go" -o -name "test_*.py" -o -name "*_test.py" -o -name "*.spec.*" \) \
  -print 2>/dev/null | wc -l | tr -d ' ')
say "test_files=$TESTS"
for d in test tests spec __tests__; do [ -d "$d" ] && say "test_dir=$d"; done

# --- CI / containers / services ---------------------------------------------------
ls .github/workflows/*.yml .github/workflows/*.yaml 2>/dev/null | sed 's/^/DETECT ci_github=/'
has .gitlab-ci.yml && say "ci=gitlab"
has .circleci/config.yml && say "ci=circleci"
has Dockerfile && say "container=Dockerfile"
ls docker-compose*.y*ml compose.y*ml 2>/dev/null | head -3 | sed 's/^/DETECT compose=/'
{ has .devcontainer/devcontainer.json || has .devcontainer.json; } && say "devcontainer=yes"

# --- existing saddle / agent artifacts -------------------------------------------
for f in AGENTS.md CLAUDE.md GEMINI.md .cursorrules init.sh scripts/verify feature_list.json progress.md session-handoff.md harness-llms.txt; do
  has "$f" && say "harness_artifact=$f"
done
[ -d .cursor/rules ] && say "harness_artifact=.cursor/rules"
[ -d .claude/skills ] && say "harness_artifact=.claude/skills"
[ -d .github/agents ] && say "harness_artifact=.github/agents"
[ -d specs ] && say "harness_artifact=specs/"
[ -d docs/saddle ] && say "harness_artifact=docs/saddle/"

# --- size / language quick profile --------------------------------------------------
FILES=$(git ls-files 2>/dev/null | wc -l | tr -d ' ')
[ "$FILES" = "0" ] && FILES=$(find . -path ./.git -prune -o -type f -print 2>/dev/null | wc -l | tr -d ' ')
say "tracked_files=$FILES"
git ls-files 2>/dev/null | sed -n 's/.*\.\([a-zA-Z0-9]\{1,4\}\)$/\1/p' | sort | uniq -c | sort -rn | head -8 | awk '{print "DETECT ext="$2" count="$1}'

say "done=1"
