# Spec-driven development flow (L3, grown up)

The saddle always installs the minimal L3 (specs/TEMPLATE.md +
feature_list.json). This reference wires a full spec-driven flow — the spec
as the human control surface, reviewed before code exists. Decide in Phase 3;
install in Phase 4.

## The three levels (know which you're installing)

- **Spec-first**: a considered spec precedes each AI-assisted task. This
  saddle ALWAYS installs spec-first — it's the L3 layer itself.
- **Spec-anchored**: the spec persists and evolves with the feature. Install
  where features live long and several people touch intent (see "anchored
  maintenance" below).
- **Spec-as-source**: humans edit only specs, never code (1:1 spec↔code
  mapping, `GENERATED FROM SPEC` markers). Do NOT install: the
  Model-Driven-Development parallel applies — risk of combining
  "inflexibility and non-determinism." Revisit yearly.

## Scale matching (the sledgehammer rule)

Scale the ceremony to the work: a small bug fix must not balloon into "4 user
stories with 16 acceptance criteria," and a quick fix in chat is fine for
typos, simple logic errors, or well-understood one-line changes. So:

| Work | Flow |
|---|---|
| Typo, one-liner, well-understood fix | No spec. Session protocol + verify is the whole ceremony. |
| Bug in a critical path, regression-prone area, or unclear root cause | Bugfix mini-spec: reproduce-as-failing-test + root-cause note + done-when. One page max. |
| Feature fitting in 1–3 sessions | Full lightweight flow (below), one spec file. |
| Large feature, several stakeholders | The saddle's 3-file split (requirements / design / tasks). |

Many focused specs beat one monolith — never a single spec for the codebase.

## The built-in lightweight flow

Four artifacts, four gates, no tooling:

1. **Interview → spec.** "Ask me one question at a time until you can write a
   thorough spec," then instantiate `specs/<feature>.md`. The spec stays
   FUNCTIONAL — what, why, for whom, and done-when. Technical decisions go in
   the plan/design section, never mixed into requirements (mixing the
   functional and technical is the biggest usability failure of spec flows —
   enforce the boundary with structure, not discipline).
   Write acceptance criteria in EARS form where possible — `WHEN <condition>
   THE SYSTEM SHALL <behavior>` — because each such sentence compiles almost
   verbatim into a runnable feature_list step.
   NEVER guess: every ambiguity becomes a `[NEEDS CLARIFICATION: specific
   question]` marker in the Open Questions section.
   Attended, markers become the next interview questions; unattended, each
   resolved marker becomes a numbered assumption in the design doc.
2. **Adversarial spec review** (fresh context; subagent if available) runs
   this checklist — checklists are unit tests for specs:
   - Any `[NEEDS CLARIFICATION]` left unresolved?
   - Is every done-when criterion testable by command or observable flow?
   - Non-goals present, and do they actually bound the work?
   - Conflicts with AGENTS.md golden rules (see constitution note below)?
   - Simplicity gate: is there a materially simpler shape that satisfies the
     same criteria? Anti-abstraction gate: does the spec invent structure the
     repo doesn't need yet?
3. **Plan.** Milestones inside the spec (or `design.md` for large features:
   architecture, data model, sequence, testing strategy), each milestone with
   acceptance criteria and the exact validation command. Validate the plan
   against AGENTS.md golden rules explicitly — that file IS this repo's
   constitution: immutable principles applied to every change. Human approves
   (attended) — the second gate.
4. **Decompose to feature_list.json.** Each milestone → entries with
   `"passes": false` and `steps` derived from the EARS criteria and
   validation commands. Mark independent entries parallel-safe (`"parallel":
   true`) only when they touch disjoint files. "Done" then traces back to the
   spec mechanically: EARS criterion → feature_list step → verify + evidence.

## Hardening rules (field-tested)

- **The spec bar:** a spec is done when *an implementer agent could build it
  without asking a single question* — a sharper test than "no markers left."
  Grill until then.
- **Durability doctrine:** artifacts that outlive a session (specs, feature
  entries, briefs) carry no file paths, no line numbers, no code snippets —
  they go stale; describe interfaces, types, and behavioral contracts. One
  exception: a prototype-derived snippet that encodes a decision more
  precisely than prose, trimmed to the decision-rich part.
- **Test seams are a spec field.** Declare the seams tests may be written at
  and confirm them before the spec freezes; no test at an unconfirmed seam.
  Prefer existing seams, the highest seam possible, and few of them.
- **Fog is not a question.** `[NEEDS CLARIFICATION]` is for sharp-but-
  unanswered questions (blockable, tickatable). What you can't yet state
  precisely goes in a "Not yet specified" section and graduates into
  questions as decisions land. "Out of scope" is scope, not sharpness — it
  never graduates.
- **Decompose as tracer bullets:** each feature_list entry cuts a narrow but
  COMPLETE path through every layer, is demoable/verifiable alone, and is
  sized to fit one fresh context window. Entries declare `blocked_by`;
  sessions work the **frontier** (pending ∧ all blockers passed) and, when
  parallel, set `claimed_by` before working (parallel-safe = disjoint areas
  of behavior, since entries never name files). Wide mechanical refactors get
  expand–contract sequencing: expand beside the old → migrate in
  blast-radius-sized batches (each blocked by the expand) → contract,
  blocked by every batch.
- **Diverse adversarial review:** run the spec-review checklist as parallel
  fresh-context reviewers, each pinned to a DIFFERENT attack constraint
  (completeness / simplicity / testability / constitution-conflict), and
  report per axis, unmerged — separation stops one axis masking another and
  stops reviewers converging on the same findings.

## Review-burden caps (specs must cost less than the diffs they govern)

The failure mode to prevent: specs so heavy that reviewing them costs more
than reviewing the code they govern. Countermeasures, mandatory: a spec is ≤
~2 pages; it never restates repo facts (link `docs/kb/` cards instead); fewer
artifacts for smaller work (the scale table above); spec changes are reviewed
as diffs like code; and generated planning text that merely paraphrases the
spec gets deleted, not reviewed.

## Compliance honesty

A hard-won field lesson: even with detailed specifications and checklists, an
agent will not reliably follow every instruction. Specs steer; only gates
enforce. Never treat the existence of a spec as evidence of conformance —
conformance is established by `scripts/verify`, the feature's executed steps,
and fresh-context review of the diff against the spec.

## Anchored maintenance (optional, for long-lived features)

Keep `specs/<feature>/` after merge; on behavior changes, update the spec
FIRST, then re-derive open tasks (new tasks map to changed requirements;
check which tasks are already complete to reap finished ones). Add a
recurring feature_list entry: spec-drift pass — do the specs still describe
the shipped behavior? Specs are version-controlled next to the code they
describe, always.

## Why this ordering is non-negotiable

The spec is reviewed before implementation because intent errors are the most
expensive errors to catch late, and unattended agents amplify whatever intent
they were given. A wrong line costs a sentence at gate 2 and a rewrite after
merge. The principle is that specifications don't serve code; code serves
specifications — and this saddle adopts exactly as much of that inversion as
current tools can enforce: the spec governs what "done" means; the gate
decides whether you're there.
