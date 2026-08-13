# Saddle Starter Kit

Drop-in scaffolding that turns any repository into an environment where AI
coding agents work reliably and humans steer. Stack-agnostic: placeholders are
marked `{{LIKE_THIS}}` and the table below maps them per ecosystem.

These files distill a broad study of agent-harness engineering into drop-in
scaffolding; every design choice is deliberate.

## What's in the box

```
AGENTS.md                    agent instructions: rules, commands, session protocol
CLAUDE.md                    one-line import so Claude Code reads AGENTS.md
init.sh                      idempotent environment bring-up + health check
scripts/verify               the definition-of-done gate (fail-fast, grep-friendly)
feature_list.json            scope + machine-checkable done-criteria, passes:false
progress.md                  append-only work log across sessions
session-handoff.md           cold-start resume state
specs/TEMPLATE.md            spec template (goal, non-goals, done-when, validation)
.github/workflows/verify.yml CI mirror of the verify gate
```

## Install (~30 minutes of your review time)

The fastest path is to let the agent install its own saddle:

1. Copy this kit's files into your repo root (don't overwrite an existing
   AGENTS.md — merge instead).
2. Tell your agent:
   > Read README.md from the saddle starter kit I just added. Fill every
   > `{{PLACEHOLDER}}` in EVERY kit file — AGENTS.md, init.sh,
   > scripts/verify, feature_list.json, and .github/workflows/verify.yml —
   > for THIS repository, using the stack table in the README. Then run
   > ./init.sh and ./scripts/verify and fix whatever breaks until both pass
   > on a clean checkout. Do not modify or delete existing tests to get
   > there.
3. Review the diff like any PR. Prune AGENTS.md to roughly one page.
4. Have the agent interview you ("ask me one question at a time") to fill
   `specs/` and `feature_list.json` for your current goals.
5. Commit. Run your first session with the protocol in AGENTS.md, watching.

The keystone is `scripts/verify` passing on a clean checkout. Until that is
true, don't delegate anything unattended.

## Placeholder map by stack

| Placeholder | TypeScript/Bun | Node/pnpm | Python | Go | Rust |
|---|---|---|---|---|---|
| `{{INSTALL_CMD}}` | `bun install` | `pnpm install` | `pip install -e ".[dev]"` | `go mod download` | `cargo fetch` |
| `{{FORMAT_CHECK_CMD}}` | `bun run format:check` | `prettier --check .` | `ruff format --check .` | `test -z "$(gofmt -l .)"` | `cargo fmt --check` |
| `{{LINT_CMD}}` | `bunx oxlint` | `eslint .` | `ruff check .` | `go vet ./...` | `cargo clippy -- -D warnings` |
| `{{TYPECHECK_CMD}}` | `bunx tsc --noEmit` | `tsc --noEmit` | `mypy .` | (covered by build) | (covered by build) |
| `{{TEST_CMD}}` | `bun test` | `pnpm test` | `pytest -q` | `go test ./...` | `cargo test` |
| `{{BUILD_CMD}}` | `bun run build` | `pnpm build` | `python -m build` | `go build ./...` | `cargo build` |
| `{{RUN_CMD}}` | `bun run dev` | `pnpm dev` | your entrypoint | `go run .` | `cargo run` |
| `{{HEALTH_CHECK_CMD}}` | e.g. `curl -fsS localhost:3000/health` | same | same idea | same idea | same idea |

No tests yet? Set `{{TEST_CMD}}` to your one smoke test and make "add
characterization tests around X" the first delegated tasks. A gate without
teeth gets gamed.

## Week-1 hardening (after the basics hold)

Add, in order of failure classes you actually fear: a sandbox for full-speed
sessions (`srt`, container, or devcontainer with an egress allowlist;
staging-only credentials), one structural test for your most important
architecture rule, an independent review pass on every agent PR, browser-driven
end-to-end checks for your top user flows, and a `skills/` folder the first
time you explain the same procedure twice.

## House rules encoded here (don't delete these)

- The anti-gaming clause in AGENTS.md and feature_list.json. Agents under weak
  checks will edit tests to "pass"; this line plus CI is the countermeasure.
- Stop-and-fix: no proceeding past a red `verify`. Ever.
- One feature per session; out-of-scope findings become follow-up entries.
- Evidence, not assertions: "passes" flips only after the listed steps ran.
- Every recurring agent mistake becomes one new line in AGENTS.md. That is how
  the saddle learns.
