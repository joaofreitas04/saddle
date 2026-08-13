# Phase 6 — Report card & handoff

## Report: `docs/saddle/report.md`

```markdown
# Saddle report — <repo> — <date>

## Layer scorecard
| Layer | Status | Evidence / gap |
| L1 Instructions (AGENTS.md) | ✅/⚠️/❌ | ... |
| L2 Environment (init.sh) | | |
| L3 Specs & scope (feature_list, specs/) | | |
| L4 State (progress, handoff) | | |
| L5 Verification (verify, CI, tests reality) | | |
| L6 Safety (sandbox rec., protected paths) | | |
| L7 Orchestration (branch/PR flow) | | |
| L8 Observability (what's measured) | | |
| L9 Memory (skills/knowledge base) | | |
✅ installed & validated ⚠️ partial (say what's missing) ❌ absent (say why)
✅ requires a matching Phase 5 evidence line — no evidence, no checkmark.
Layers Phase 5 cannot fully prove (L6 safety, L8 observability, L9 memory),
statically-verified-only CI, and a files-only self-graded cold-start cap at
⚠️ until operationally proven; say so rather than round up.

## Automation coverage
The operations map per references/autonomy-coverage.md: state (✅/🟡/⛔) per
lifecycle operation, % automated, delta vs the previous audit, and the named
blocker for every 🟡/⛔ — each with its matching feature_list entry. An
operation may be ⛔ only for one of the three legitimate reasons
(unenumerated failure modes / no tested undo / goal-choice judgment).

## Saddle Score (published, formula-backed — never vibes)
One number for the badge, four inputs, all evidenced:
score = 0.40 × coverage (✅ operations ÷ scorable operations, as %)
      + 30 × teeth freshness (proven <30 days ago = 1.0; <90d = 0.5; else 0)
      + rung points (A1=5, A2=10, A3=15, A4=20)
      + 10 × state freshness (kb probe dates and handoff <90 days = 1.0)
Write `docs/saddle/score.json` and the README badge, e.g.
`https://img.shields.io/badge/Saddle-84_·_A2_·_2026--08--11-2ea44f`.
The score exists to be re-earned: saddle-check recomputes it on every
audit, and a decayed score IS the finding.

## Autonomy rung earned
The ladder, defined here once: A0 pre-saddle · A1 supervised pairing ·
A2 delegated tasks, human reviews PRs · A3 unattended one-shots ·
A4 fleet/ticket-driven. Award strictly by evidence: A1 requires a trusted
green gate; A2 requires teeth-proven gate + state files + CI parity; A3+ is
never awarded at install time — it must be earned in operation (stable
one-shot record). Name exactly what blocks the next rung.

## Validation evidence
The Phase 5 record: bootstrap, green gate, canary A red run, canary B red
run, cold-start answers, CI parity — plus, when installed: the tracker
read/write probe and the guardrail-hook block canary.

## Assumptions to confirm
Carried from design — the first thing a returning human should read.

## Week-1 hardening backlog
Also filed as feature_list.json entries:
- sandbox/containment for full-speed sessions (if absent)
- one structural/architecture check (if a rule was identified)
- characterization tests for <hot module> (if tests are thin)
- independent review pass on agent PRs
- E2E smoke of the top user flow (if UI/API)
- first skill: <the procedure discovery showed is repeated>
- coverage or mutation threshold on the test tier (only once the suite is
  trusted — a threshold on a gamed suite is theater)
- KB freshness pass: re-probe llms.txt URLs and doc versions (recurring)
```

## Handoff duties

1. Append the install entry to `progress.md` (what was installed, verified,
   decided; the canary evidence in one line each).
2. Write `session-handoff.md`: state = saddle installed on `saddle/init`;
   next step = human review of design assumptions + merge; watch-outs from
   discovery.
3. PR (or PR-shaped summary if no remote): what/why per artifact, the report
   card inline, assumptions flagged, and the sentence "the merge is yours" —
   because it is. The human merging is the saddle's last hard gate, and the
   report exists so that decision takes minutes, not an afternoon.

## Upgrade/audit mode

Same scorecard against the *existing* saddle. Grade each artifact
(current / stale / conflicting / missing), run the Phase 5 validation against
the existing gate (teeth canaries included — old gates rot), and deliver:
report + minimal-diff proposals per gap, largest risk first. Never rewrite
wholesale what a targeted diff can fix — the repo's history and the team's
muscle memory are saddle assets too.
