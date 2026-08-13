# Universal saddle install prompt

For agents without Agent Skills support (or quick one-off use): paste this
whole file as the task, or attach it and say "follow INSTALL_PROMPT.md".
It condenses the `saddle-up` skill — same phases and gates, no
dependencies; the full skill adds deeper procedures (live stack
intelligence, marketplace vetting, tracker contracts, autonomy-coverage
scoring) that this prompt only sketches.

---

You will saddle up the repository you are in — installing the groundwork
(an **agent harness**): the
scaffolding that lets AI coding agents work autonomously and reliably while
humans steer. Work on branch `saddle/init`, commit per artifact, and follow
two hard rules throughout: never proceed past a failing check (stop-and-fix),
and never weaken, remove, or edit a check or test to make it pass.

## Phase 0 — Preflight
Git repo with clean-enough tree; create `saddle/init`. If saddle artifacts
already exist (AGENTS.md, verify script, feature list), switch to AUDIT mode:
grade what exists, propose diffs, don't overwrite. If the user is unavailable,
run UNATTENDED: sensible defaults, every one logged as a numbered assumption.

## Phase 1 — Discovery (evidence, not guesses)
Identify ecosystems, package manager, monorepo layout, declared scripts, CI,
services, existing agent files. THE RULE: any command the saddle will claim
(install/format/lint/typecheck/test/build) must be EXECUTED now — record exit
code and wall time. Run the test suite; count what actually passes ("no
tests" is a finding, not a blocker). Skim architecture enough for a 5–10 line
orientation map and one enforceable rule. Write `docs/saddle/discovery.md`.

## Phase 2 — Interview (attended) or defaults (unattended)
One question at a time, only what the repo can't answer: inviolable rules,
protected paths/credentials, personal definition of done, next 3–5 real
goals, autonomy appetite, review workflow, "what do newcomers get wrong?".
Unattended defaults: protect `.env*`/secrets/deploy dirs; done = gate green +
steps executed; target autonomy = PR-review level, never higher; goals =
gaps discovery found.

## Phase 3 — Design ⛔ human gate
Write `docs/saddle/design.md`: verify tiers with the measured commands and
times; gap analysis (no tests → smoke test now + characterization backlog; no
linter → ecosystem default or defer with note); knowledge-base plan (which
4–7 load-bearing deps get cards, each source PROBED: try
`https://<docs-domain>/llms.txt` — record ✅ URL or ❌ + date); capability
plan (marketplace skills/MCPs worth proposing — vetted, install only on
approval); spec-flow choice; work-tracking choice (Jira/Linear/GitHub/local —
exactly ONE source of truth); file plan; assumptions. STOP for approval
(unattended: present it, proceed only if the original instruction authorized
end-to-end work).

## Phase 4 — Install
- `AGENTS.md` (~1 page): project one-liner; golden rules including VERBATIM:
  "It is unacceptable to remove or edit tests because this could lead to
  missing or buggy functionality."; commands table; the session protocol
  below; orientation map; routing to docs. Add `CLAUDE.md` containing
  `@AGENTS.md`.
- `init.sh` (+x): idempotent env bring-up + health check; grep-friendly
  `INIT OK/FAIL <step>` lines.
- `scripts/verify` (+x): THE definition of done. Fail-fast steps with
  `VERIFY OK/FAIL <step>` lines: format → lint → typecheck (fast tier, aim
  <30s) → tests → build (full tier). A `fast` argument runs the fast tier.
  Only commands proven in Phase 1 may appear.
- `feature_list.json`: real goals as entries `{id, category, blocked_by[],
  description, steps[], passes:false}` — steps are runnable commands or
  observable flows (behavioral, no file paths); flip `passes` only after
  executing them; sessions work the frontier.
- `progress.md` (append-only session log) and `session-handoff.md` (cold
  resume state: current state / next step / blockers / watch-outs).
- `specs/TEMPLATE.md` + lightweight spec flow: interview → spec (goal,
  non-goals, constraints, machine-checkable done-when, validation commands)
  → adversarial spec review in fresh context → milestones → decompose into
  feature_list entries.
- CI workflow that runs `./scripts/verify` itself (same script, no
  re-implementation).
- `docs/kb/`: README router; one card per load-bearing dep (≤1 page:
  version from lockfile, official docs + probed llms.txt status + docs-MCP
  id if available, how this repo uses it, append-only gotchas);
  `conventions.md` from discovery observations; `decisions.md` ADR-lite.
  Store URLs and lessons, never vendored doc dumps.
- Merge with any existing files — never clobber; flag removals in the PR.
  Leave no `{{PLACEHOLDER}}` anywhere.

## Phase 5 — Validation (prove it, then try to break it)
1. Fresh-state `./init.sh` → exit 0. 2. `./scripts/verify` → exit 0.
3. TEETH CANARIES: add a deliberately failing test → gate MUST exit non-zero;
   revert → green. Break a source file (type/lint/syntax) → MUST fail;
   revert → green. A canary passing green means the gate is broken — fix it,
   don't rationalize.
4. COLD-START: from repo files alone, a fresh session must answer: what is
   this project; what command proves done; what single task is next; what
   happened last session. Wrong answer = fix the corresponding file.
5. CI parity (statically if no runner). Record all evidence (commands, exits,
   output lines) in `docs/saddle/report.md`.

## Phase 6 — Report & handoff ⛔ human gate
`docs/saddle/report.md`: scorecard over the nine layers (instructions,
environment, specs/scope, state, verification, safety, orchestration,
observability, memory/KB) with ✅/⚠️/❌ + evidence (✅ only with a Phase 5
evidence line); the automation coverage map — which lifecycle operations now
run agent-side, which are partial or human-required, each gap's blocker
named and filed as work; the autonomy rung EARNED
(supervised → delegated-PR → unattended — never award unattended at install
time); week-1 backlog (sandboxing, one structural check, characterization
tests, review pass, E2E smoke, first skill) filed as feature_list entries.
First progress.md entry; handoff file; PR description ending "the merge is
yours." The human merges. Always.

## Session protocol (goes in AGENTS.md verbatim, adapted)
```
orient:    read AGENTS.md, git log, progress.md, session-handoff.md
baseline:  ./init.sh && ./scripts/verify — world green BEFORE work
select:    ONE frontier item (passes:false AND all blocked_by passed;
           array order = priority) — or the assigned task
implement: smallest change satisfying its done-criteria
verify:    ./scripts/verify + the item's own steps; evidence, not assertions
record:    commit; progress entry; handoff update; flip passes only after
           real verification; file follow-ups instead of scope-creeping
```

## Honesty rules
Blocked (deps won't install, suite too broken, docs unreachable)? Downgrade
scope visibly, record the blocker, file the fix as the top backlog entry.
Never fake green, never cite an unprobed source, never install trust/allow
configs without approval. An honest smaller saddle beats a broken
impressive one.
