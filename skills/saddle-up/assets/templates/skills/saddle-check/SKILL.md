---
name: saddle-check
description: Quick health check of this repo's saddle — re-prove the gate's teeth with fresh canaries, cold-start test, probe checks, coverage re-score, drift report. For structural upgrades, run the full saddle-up installer instead.
disable-model-invocation: true
---

# saddle-check — does the saddle still bite?

Gates rot silently; this command re-earns trust. Read-only except for
canaries (reverted) and the report.

1. **Gate teeth, fresh.** `./scripts/verify` green → inject a failing test →
   MUST go red → revert → green. Then a lint/type breakage → red → revert.
   A canary that passes green is a broken gate: fixing it becomes the
   session, and the finding goes in the report.
2. **Cold-start.** From repo files alone (fresh subagent if available):
   what is this project, what proves done, what's next on the frontier,
   what happened last session? A wrong answer = the owning file drifted.
3. **Probes.** Tracker capability (one read) if `docs/agents/tracker.md`
   exists; guardrail hooks blocked by a synthetic forbidden command if
   installed; CI workflow still invokes `./scripts/verify` verbatim.
4. **Drift scan.** feature_list entries stale vs reality? `docs/kb/` card
   probe dates older than ~a quarter? progress/handoff disciplines held?
   AGENTS.md rules still matching how the repo actually works?
5. **Re-score coverage.** Update the report's ✅/🟡/⛔ operations map and
   the delta since last audit; every degradation or gap becomes a published
   work item on the frontier.

6. **Recompute the Saddle Score** (formula in the report's Score section —
   coverage, teeth freshness, rung, state freshness) and write
   `docs/saddle/score.json`:
   `{"score": N, "rung": "A2", "coverage_pct": N, "teeth_proven": "YYYY-MM-DD"}`.
   Update the README badge line if present. Evidence rules apply to every
   input — a stale teeth date is reported stale, never rounded up.

Redact secrets from all recorded evidence (env-var loops; `<REDACTED>`;
signal lines only). Append the audit as a `progress.md` entry with
pointers. Honesty rules apply: evidence lines for every claim; self-graded
checks marked as such. Structural gaps (missing layers, new stack, tracker
migration) → recommend a full `saddle-up` upgrade run rather than patching
here.
