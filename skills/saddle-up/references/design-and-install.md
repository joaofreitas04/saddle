# Phase 3 — Design (⛔ human gate) and Phase 4 — Install

## Design: `docs/saddle/design.md`

The design doc is the one artifact a busy human will actually read before
granting you install rights — brevity and honesty are the features. Template:

```markdown
# Saddle design — <repo> — <date>

## Summary
3–5 lines: what will be installed and the single biggest gap found.

## Verify gate design
| Tier | Step | Command | Measured time | Source |
fast:  format, lint, typecheck (target <30s total)
full:  + tests, build (+ structural checks if designed)
Every command here appeared in discovery's Verified commands table. If a tier
is empty (no linter, no tests), say so and point to the gap plan.

## Gap analysis & remediation
No tests → smoke test now + characterization campaign as backlog entries.
No linter → adopt the ecosystem default (measured install) or defer with note.
Flaky suite → quarantine list + fix entry; NEVER silently exclude.
Slow suite → fast/full split; sampled mode only with human sign-off.
Monorepo → state the placement decision (default: root install, gate fans
out to workspace commands; nested AGENTS.md later where packages diverge).
Non-GitHub CI → verify job merged into the EXISTING CI config, never a
parallel system. Windows-primary team → name the gate strategy (WSL
requirement, or a cross-platform runner) explicitly.

## Files to install
Table: file → action (create / merge-with-existing / skip+why).

## Golden rules proposed
The 4–7 rules going into AGENTS.md, including the anti-gaming clause verbatim
and any human-supplied invariants.

## Knowledge base plan
Which dependency cards (4–7, load-bearing only), each with its live-probed
source (llms.txt URL ✅/❌ + date, docs-MCP id) — per
references/knowledge-base.md and the stack-intel Part 1 probes.

## Capability plan (marketplace skills & MCPs)
Table from stack-intel Part 2: skill/MCP | source URL | provenance tier |
gap it fills | install target. Installs happen only on approval, pinned, at
project scope; unattended runs recommend-only. No entry without its
SKILL.md and scripts having been read.

## Spec flow
Which levels of the saddle's own spec flow to install (spec-first always;
spec-anchored where features live long), with one line of why; per
references/spec-driven.md.

## Trust configuration (optional, host-specific)
Pre-approved safe commands (the gate, tests) and hard denials (push, publish,
deploy) for the host tool — e.g. a .claude/settings.json allow/deny list.
Propose here; install only with human approval (unattended: propose-only).
Action-time guardrails belong here too: where the host supports
pre-execution hooks (e.g. PreToolUse), propose deny hooks for
contract-forbidden operations (force-push, history rewrite, editing
scripts/verify or test files to weaken them) — a prompt rule can be
rationalized past; an exit-code block cannot. A hook gets its own teeth
test: pipe a synthetic forbidden command through it and require the block.

## Work-tracking plan
Tool binding (which tracker, project/board, access path by name — no
secrets), the one-source-of-truth choice (tracker vs local feature list),
the team-contract summary (states, templates, labels, dispatch signal), and
per-user connection status with the personal-setup checklist for anyone not
yet connected — per references/trackers.md.

## Target autonomy rung & what it requires
e.g., "A2 after this install; A3 blocked on: E2E smoke + review agent."

## Autonomy-coverage target
Which lifecycle operations run agent-side after this install, which stay
🟡/⛔, and each blocker named (per references/autonomy-coverage.md). Default
to automation: "human-required" needs one of the three legitimate reasons,
and every gap ships as a feature_list entry, not a footnote.

## Assumptions (unattended) / Open questions (attended)
Numbered. This section is why the gate exists.
```

**Stop here.** Attended: wait for approval and fold in edits. Unattended:
present the doc, state you are proceeding on the defaults, and continue only
if the user's original instruction authorized end-to-end work.

## Install: rules that keep it safe and reviewable

1. **Instantiate, never copy blind.** Fill templates from `assets/templates/`
   with discovery's verified values. Search the result for `{{` before
   committing — a leftover placeholder is a broken saddle.
2. **Merge, don't clobber.** Existing AGENTS.md/CLAUDE.md/CI: produce a merged
   version that preserves their content, and call out every removal in the PR
   description. Existing scripts named `verify` or `init.sh`: pick a
   non-colliding path and note it. Conflicting rules: the existing
   human-authored rule wins pending an explicit human decision. Other agent
   files found (.cursorrules, GEMINI.md, .github/copilot-instructions...):
   fold their content into AGENTS.md and reduce them to a one-line pointer —
   parallel instruction truths drift.
3. **AGENTS.md discipline.** ~1 page. Project one-liner, Golden Rules,
   commands table, session protocol, orientation map, doc pointers. Every line
   must pass: "would an agent plausibly err without this?" Bloat causes rule
   loss — the file's power is inverse to its length.
4. **feature_list.json with real work.** Entries from the human's goals (or
   unattended defaults), each with executable steps and `"passes": false`.
   The saddle's own week-1 hardening items go here too — the saddle tracks
   its own improvement.
5. **CI parity.** The workflow runs `./scripts/verify` — the same script, not
   a re-implementation. If CI can't run a step (no browser, no DB), the step
   degrades identically in both places or the difference is documented in
   AGENTS.md.
6. **Executable bits and shebangs** on `init.sh` and `scripts/verify`
   (`chmod +x`); POSIX-safe constructs only.
7. **Commit story.** One commit per artifact group with clear messages
   (`saddle: add verify gate`, `saddle: add AGENTS.md`...), all on
   `saddle/init`. The PR should read as an auditable install log.
8. **Knowledge base.** Build `docs/kb/` per references/knowledge-base.md:
   router README, the planned dependency cards with *probed* sources (record
   ❌ honestly), conventions.md seeded from discovery observations,
   decisions.md seeded with this install's choices, and the out-of-scope/
   directory (may start empty — its README explains the rejection-store
   rules). Wire the AGENTS.md routing lines and the session-protocol append
   rule.
9. **Spec flow.** Install the saddle's own spec flow per
   references/spec-driven.md (specs/ + the adversarial-review step; the
   3-file split for large features).
10. **Trust config (only if approved).** Write the host tool's allow/deny
    list exactly as designed — allow the gate and test commands, deny
    push/publish/deploy. Never widen it beyond the design doc. Shipped
    Claude-native templates: `assets/templates/claude/settings.json`
    (allow/deny + hook wiring), `claude/hooks/protect-saddle.sh`
    (PreToolUse blocker — gets its own teeth test), and
    `claude/agents/saddle-reviewer.md` (clean-context two-axis reviewer
    subagent, installable to `.claude/agents/`).
11. **Tracker contract (when the design chose a tracker).** Write
    `docs/agents/tracker.md` per references/trackers.md — states, templates,
    labels, canonical-verbs table — plus the AGENTS.md routing line and the
    per-user connection checklist for anyone not yet connected.
12. **Mint the operating skills** (when the host supports skills). Copy
    `assets/templates/skills/` (saddle-session, saddle-spec,
    saddle-check) into the repo's skill directory (`.claude/skills/` or
    host equivalent) and COMMIT them — they travel with the repo, reaching
    every skills-capable agent as commands. Governance: all three are
    user-invoked (they are human steering surfaces). Two-truths rule: these
    skills load repo files and never restate their rules — AGENTS.md and
    the templates stay canonical, so skill-less agents lose ergonomics, not
    correctness. Add a "Commands" line to AGENTS.md's routing table naming
    the three.
