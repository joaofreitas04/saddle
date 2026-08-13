# Phase 5 — Validation

The purpose of this phase is asymmetric: passing checks prove little, so you
will also try to make the gate FAIL on purpose. A saddle whose gate cannot go
red is a decoration, and every autonomy decision built on it is unsafe. Record
every step's actual command and output in `docs/saddle/report.md`'s
validation section — evidence, not assertions.

## Checklist (all required)

### 1. Bootstrap green
From a clean state (fresh clone or `git clean -xdf` in a scratch copy if
safe): `./init.sh` exits 0 and prints its INIT OK lines.

### 2. Gate green
`./scripts/verify` exits 0 on the untouched branch. Also run
`./scripts/verify fast` and confirm it is actually fast (measure it).

### 3. Gate-teeth canaries (the heart of this phase)

**Canary A — failing test.** Add a test that must fail, using the repo's own
test idiom:

| Ecosystem | Canary |
|---|---|
| node | `test/zz_canary.test.js` with `assert.strictEqual(1, 2)` (node:test) or the repo's framework equivalent |
| python | `tests/test_zz_canary.py` with `def test_canary(): assert False` |
| go | `zz_canary_test.go` with `t.Fatal("canary")` |
| rust | `#[test] fn zz_canary() { panic!("canary") }` in a tests file |
| jvm | a JUnit test asserting `fail("canary")` |
| other | any test the suite discovers that unconditionally fails |

Run `./scripts/verify`. Required outcome: **non-zero exit** with the failure
visible in output. Then delete the canary and re-run to green.

**Canary B — broken source.** Introduce a syntax/type/lint violation in a
real source file (e.g., an unclosed brace or an obviously unused variable the
linter flags). Run the gate; require non-zero. Revert (`git checkout -- <file>`)
and re-run to green.

If either canary passes green: the gate is broken (test step not wired, wrong
directory, error swallowed by `|| true`, missing pipefail...). Fix the gate
and repeat. Do not proceed, do not rationalize.

No-test repos: Canary A targets the smoke test this install created; if the
gate genuinely has no runnable test step, mark Canary A "N/A — gate not
teeth-proven on tests," cap the autonomy rung below A2, and make the first
backlog entry the one that changes that.

Slow suites: canaries may target the relevant verify STEP alone (test step
for Canary A, lint step for Canary B) with ONE final full-gate run at the
end — five full one-hour runs is waste, not rigor. Label partial runs as
such in the evidence.

### 4. Cold-start test
Simulate the next session with zero memory. If subagents are available, spawn
one with only: "You are in <repo>. Using only files in the repo, answer: (a)
what is this project, (b) what command proves work is done, (c) what single
task would you pick up next and why, (d) what happened in the last session."
Otherwise self-check strictly from files. Pass = all four answers are correct
and grounded in AGENTS.md / feature_list.json / progress.md /
session-handoff.md. A wrong answer means the corresponding file needs fixing.

### 5. CI parity
The workflow invokes `./scripts/verify` itself, parses as valid YAML, and
contains a real toolchain step (no leftover placeholders). If a runner can't
be executed here, statically confirm and mark "CI: statically verified only"
in the report — honestly labeled partial evidence beats implied full
evidence.

### 6. Tracker probe (only when a tracker was wired — see trackers.md)
One read (fetch an issue / whoami) proving the capability; plus one
write-then-cleanup canary (comment or sandbox issue) where the team allows
writes — otherwise "write path: statically verified only."

### 7. Guardrail-hook teeth (only when action-time hooks were installed)
Pipe a synthetic forbidden command through the hook and require the block
(non-zero / denied). A hook that doesn't block its own canary is decoration.

## Recording

For each item: the command run, exit code, duration, and 1–3 output lines
that prove the result — **redacted first**: secrets become `<REDACTED>`,
credentials stay in env vars so they never enter a transcript or report,
and only signal-carrying lines are quoted. The canaries' red runs are the
most important evidence in the whole install — show them.
