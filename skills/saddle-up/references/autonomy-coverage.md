# Autonomy coverage: the saddle's actual goal

The saddle is not a set of files; the files are the means. The goal is
**coverage**: moving the maximum safe share of this repo's development
operations from human-executed to agent-executed-with-human-steering. This
reference defines how coverage is targeted in Phase 3 (design) and scored in
Phase 6 (report), and how every gap becomes work instead of a shrug.

## The operations map

Score each lifecycle operation. "Automated" means all three exist and were
validated: an **entry point** (how work reaches an agent), a **feedback
loop** (how the agent knows it succeeded — mechanical, never self-graded),
and an **approval boundary** (what a human signs off).

| Operation | Agent-run looks like | Needs (layers) |
|---|---|---|
| Feature development | spec → plan → implement → verify → PR | L1–L5 |
| Bug fixing | reproduce as failing test → fix → verify | L3–L5 |
| Refactoring / debt | named campaigns; behavior pinned by tests | L5, L9 |
| Test authoring | TDD + characterization; mutation-audited | L5 |
| Code review | self-review + fresh-context reviewer before human | L5, L7 |
| Documentation | docs-as-code, KB cards, runbooks from incidents | L5, L9 |
| Dependency & drift upkeep | janitor passes: upgrade-until-green, dead code | L5, L8 |
| Security scanning | scan → investigate shortlist → revalidate | L5, L6 |
| Incident response | debug from telemetry; postmortem drafts | L2, L8 |
| CI / repo chores | triage, labels, release notes, scheduled sweeps | L6, L7 |
| Project decomposition | planning ticket → task graph → unblocked pickup | L3, L7 |
| Saddle upkeep | trace-driven AGENTS.md/check/KB improvements | L8, L9 |
| Ops-grade actions (deploy, migrate, release) | policy-gated execution — see below | project-defined |

States: ✅ automated (all three pieces validated) · 🟡 partial (runs
agent-side but a piece is missing — say which) · ⛔ human-required (blocker
named).

## Closure rules — how gaps become work

1. **Every 🟡/⛔ generates a published work item** — a feature_list entry,
   or the tracker contract's `publish` verb when a tracker is truth — naming
   the missing piece: a check, a telemetry hookup, a policy document, a
   scoped credential capability, a skill. No silent gaps: an unnamed gap
   reads as "covered" and that lie compounds.
2. **Default to automation.** An operation may stay ⛔ human-required for
   exactly three reasons, each with its closure path:
   - *Unenumerated failure modes* → enumerate them; write the policy
     artifact; the operation becomes policy-gated and automatable.
   - *No tested undo* → build and drill the reversibility (rollback,
     expand/contract, flags); then automate.
   - *Goal-choice judgment* (priorities, unprecedented risk tradeoffs,
     spend beyond agreed budgets) → permanently human, **by design** — list
     it under the human's steering duties, not under debt.
   Anything claimed ⛔ without one of these three reasons is actually 🟡.
3. **Ops-grade operations are project possibilities, not skill defaults.**
   When THIS project wants autonomous deploys/migrations/releases, the
   workflow designs it in-project: policy-as-code (what may run when,
   halt conditions), tested reversibility, post-action verification against
   live signals, scoped capabilities the agent invokes but never holds, and
   halt-and-page for anything outside policy — earned rung by rung, staging
   before production. The skill ships this *shape*; the project owns the
   specifics (they live in docs/saddle/ and the repo's policy files).
4. **Coverage is re-scored on every audit run.** The report card carries the
   map, the % automated, and the delta since the last run — the saddle's
   own KPI is how much of the lifecycle it has absorbed safely.

## The human's steady-state job (what "steer" means when coverage is high)

Write and approve specs and policies; review evidence at the boundaries
(merges, policy changes, coverage-state promotions); choose goals and
priorities; resolve `[NEEDS CLARIFICATION]` markers; absorb halt-and-page
escalations; and periodically spot-read transcripts and progress logs so the
gates themselves stay honest. Everything else is the agents' job — and when
it isn't yet, the backlog says exactly why.
