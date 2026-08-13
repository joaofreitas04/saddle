---
name: saddle-spec
description: Take an idea to a frozen, reviewed spec and frontier work entries — interview (facts looked up, decisions asked), EARS done-when criteria, adversarial checklist review, tracer-bullet decomposition into feature_list.json.
disable-model-invocation: true
---

# saddle-spec — intent to executable scope

Scale check first: typos and well-understood one-liners need no spec — just
run a session. Critical-path bugs get a one-page mini-spec (repro as failing
test + root cause + done-when). Features get the full flow:

1. **Interview.** One question at a time, each with your recommended answer.
   Facts you can look up (code, configs, git, web) are YOUR job — never ask.
   Decisions are the human's — never self-answer. Every remaining ambiguity
   becomes `[NEEDS CLARIFICATION: question]` in the spec's Open questions.
2. **Write the spec** from `specs/TEMPLATE.md`: functional only (what/why),
   done-when in EARS form ("WHEN <condition> THE SYSTEM SHALL <behavior>"),
   non-goals that actually bound the work, ≤2 pages, no repo facts restated
   (link `docs/kb/` cards), no file paths (they rot).
3. **Adversarial review** in a fresh context (subagent if available), as a
   checklist: unresolved markers? every criterion testable? non-goals real?
   conflicts with AGENTS.md golden rules? a materially simpler shape?
   The spec FAILS while any marker remains. Bar: an implementer could build
   this without asking a single question.
4. **Decompose** into `feature_list.json` entries: tracer bullets (narrow but
   complete path through every layer, demoable alone, sized to one fresh
   context window), `blocked_by` edges for ordering, steps copied from the
   EARS criteria, all `passes:false`. Wide mechanical refactors: expand →
   blast-radius migration batches → contract.

Done when: the spec is frozen with zero open markers and every criterion
exists as a runnable step on a frontier entry.
