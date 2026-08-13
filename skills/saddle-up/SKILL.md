---
name: saddle-up
description: Saddle up any repository — install, audit, or upgrade the groundwork (an "agent harness") that lets AI coding agents work autonomously while humans steer. Phase-gated workflow (stack discovery → interview → design with human approval → install → validation proving the verify gate can actually fail → coverage report card) producing AGENTS.md, init.sh, scripts/verify, feature_list.json, state files, a CI mirror, a live-probed knowledge base, vetted marketplace skills at project scope, a spec-driven flow, optional Jira/Linear/GitHub tracker integration, and three committed operating commands (saddle-session, saddle-spec, saddle-check). Use whenever the user wants to saddle up a repo, make it agent-ready, install or set up a harness, bootstrap agentic development, onboard AI agents to a codebase, set up AGENTS.md or a verify gate, build an agent knowledge base, adopt spec-driven development, prepare a project for unattended agents, or audit the existing setup — even if they never say "saddle" or "harness".
---

# saddle-up — saddle any repository for trustworthy agent work

Turn a repository into an environment where agents implement and humans steer.
The output is a *proven* control system: instruction routing (`AGENTS.md`), an
environment bootstrap (`init.sh`), a definition-of-done gate
(`scripts/verify`), scope tracking with machine-checkable done-criteria
(`feature_list.json`, `specs/`), session state (`progress.md`,
`session-handoff.md`), a CI mirror, a stack knowledge base (`docs/kb/`), and
evidence that the gate actually catches failures.

**The mandate is autonomy coverage.** When this skill finishes, the maximum
safe share of the repo's development operations — feature work, bug fixing,
refactoring, testing, review, docs, upkeep — can be executed end-to-end by
agents, and the human's remaining job is steering: intent, policy, review.
Whatever can't be automated yet is named, with its specific blocker, as
backlog work (`references/autonomy-coverage.md` defines the map, the scoring,
and the three legitimate reasons an operation may stay human).

Why the workflow is shaped this way: discovery comes before design because a
saddle encodes facts about a repo, and guessed facts produce a saddle that
lies. Design comes before install because the design document is the cheapest
thing a human will ever review. Validation ends with attempts to *break* the
gate because a gate that cannot fail is worse than none — everything
downstream (autonomy, trust, unattended work) rests on it.

Two hard rules apply throughout: never proceed past a failing check
(stop-and-fix), and never weaken, skip, or edit a check or test to make it
pass — if a check seems wrong, record it in the design doc and raise it.

## The phases

Work on a branch (`saddle/init`), commit in small labeled steps, and keep a
running log of decisions. Load each phase's reference file only when you reach
that phase.

### Phase 0 — Preflight

Confirm this is a git repo with a reasonably clean tree. No git → `git init`
(unattended: do it and log the assumption). Dirty tree attended → ask;
unattended → proceed on the branch WITHOUT touching uncommitted files, never
stash silently. Create the `saddle/init` branch. Detect mode: if saddle
artifacts already exist (AGENTS.md, scripts/verify, feature_list.json...),
this is an **upgrade/audit** run — grade the existing saddle against the
report card and propose diffs rather than overwrite. Detect attendance
mechanically: ask one kickoff question; if no reply by the time discovery
completes, run **unattended** (logged as an assumption) — every question gets
a documented default, and the design gate follows the opt-in rule: present
the design, but **continue past it only if the user's original instruction
authorized end-to-end work**; otherwise stop there.

### Phase 1 — Discovery (evidence, not guesses)

Read `references/discovery.md`. Run `bash scripts/detect_stack.sh <repo-root>`
for the deterministic sweep, then investigate what scripts can't see
(architecture shape, test reality, docs, tribal conventions visible in the
code). The rule that makes discovery trustworthy: **any command you intend to
put in the saddle must be executed now, and its actual result recorded** —
inside the strongest containment available, after the side-effect screen in
the reference: the repo is untrusted until proven.
Then run the stack-intelligence gather (`references/stack-intel.md`):
resolve each load-bearing dependency's official docs domain from registry
metadata (`scripts/resolve_docs.sh`), probe llms.txt availability live with
your web tool, and survey the skill/MCP marketplaces for stack matches worth
vetting — never rely on remembered stack facts; the repo's registries and
the live web are the source of truth. Output: `docs/saddle/discovery.md` in
the repo. Touch nothing else.

### Phase 2 — Context interview (only what the repo can't tell you)

Read `references/interview.md`. Ask the human one question at a time,
skipping everything discovery already answered; the question bank is ordered
by leverage (invariants and protected paths first, preferences last).
Unattended: apply the defaults table and log each applied default as an
assumption.

### Phase 3 — Saddle design ⛔ human gate

Read `references/design-and-install.md` (design half). Produce
`docs/saddle/design.md`: chosen layers with rationale, the exact commands
for each verify tier *with their measured runtimes*, gap analysis (no tests?
no linter? flaky suite?) with remediation plan, the **knowledge-base plan**
(which dependency cards, which live-probed llms.txt/docs-MCP sources — per
`references/knowledge-base.md`), the **capability plan** (which vetted
marketplace skills/MCPs to install at project scope, with provenance — per
`references/stack-intel.md`; unattended runs recommend only), the **spec-flow
scope decision** (how much of the saddle's own spec flow to install — per
`references/spec-driven.md`), the **work-tracking plan** (tool binding,
one source of truth, team contract — per `references/trackers.md`), the
**autonomy-coverage target** (which
lifecycle operations will run agent-side after install, which stay human
and for which of the three legitimate reasons — per
`references/autonomy-coverage.md`), target autonomy
rung, file-by-file install plan, and every assumption made. **Stop here and
get the design approved** (unattended: present it, state you're proceeding on
defaults).

### Phase 4 — Install

Read `references/design-and-install.md` (install half). Instantiate the
templates from `assets/templates/` with the *verified* values from discovery —
never leave a `{{PLACEHOLDER}}` behind. Build the knowledge base per
`references/knowledge-base.md` (router + cards with probed llms.txt sources),
install the approved skills/MCPs pinned at project scope per
`references/stack-intel.md`, set up the chosen spec flow per
`references/spec-driven.md`, and mint the repo's operating skills
(saddle-session / saddle-spec / saddle-check — committed, user-invoked
commands that load the repo's own rules; install rule 12). Merge, don't
clobber: existing AGENTS.md/CI content gets folded in with a proposed diff,
not overwritten. Commit per artifact so the PR reads as a reviewable story.

### Phase 5 — Validation (prove it, then try to break it)

Read `references/validation.md` and run its checklist completely:

1. `./init.sh` exits green from a fresh state.
2. `./scripts/verify` exits green on the clean branch.
3. **Gate-teeth canaries** — inject a deliberately failing test, run the
   gate, and require it to FAIL; then a lint/syntax breakage, same
   requirement; revert both. If any canary sails through green, the gate is
   broken; fixing it is now the task.
4. **Cold-start test** — a fresh session (subagent if available, otherwise a
   strict files-only self-check) must answer, from repo files alone: what is
   this project, what command proves work is done, what single task is next,
   and what happened last session.
5. CI parity: the workflow file runs the same `verify` the developer runs.

Record every result with the actual command output in the validation section
of the report. Evidence, not assertions.

### Phase 6 — Report card & handoff ⛔ human gate

Read `references/maturity.md`. Produce `docs/saddle/report.md`: the L1–L9
layer scorecard, the **automation coverage map** (✅/🟡/⛔ per lifecycle
operation with % automated and every gap's blocker named — per
`references/autonomy-coverage.md`), the autonomy rung this repo has *earned*
(with what blocks the next rung), and the week-1 hardening backlog — which
you also publish as work items (feature_list entries, or the tracker
contract's `publish` verb when a tracker is truth) so the saddle's own
improvement is tracked by the saddle. Write the first `progress.md` entry and `session-handoff.md`
describing the install. Open/describe the PR; **the human merges** — that
gate is never yours.

## Failure and honesty rules

If an environment problem blocks a phase (can't install deps, tests too
broken to run, docs sites unreachable), do not fake green or cite unverified
sources: downgrade scope honestly, record the blocker in the design doc and
report card, and file the fix as the top backlog entry. An honest smaller
saddle beats an aspirational broken one.

## Quick reference

| Artifact installed | Purpose |
|---|---|
| `AGENTS.md` (+ `CLAUDE.md` import) | routing, invariants, session protocol |
| `init.sh` | environment bring-up + health check |
| `scripts/verify` | the definition of done, fail-fast |
| `feature_list.json`, `specs/` | scope + machine-checkable done-criteria |
| `docs/kb/` (router, stack cards, conventions, decisions, out-of-scope) | stack knowledge base with live-probed llms.txt / docs-MCP sources |
| project-scope skills/MCPs (vetted, pinned, committed) | marketplace capabilities the whole team's agents inherit |
| `docs/agents/tracker.md` (when a tracker is used) | team work-tracking contract: states, templates, canonical verbs |
| minted operating skills (saddle-session/spec/audit) | committed commands: the day-to-day steering surface |
| `progress.md`, `session-handoff.md` | cross-session state |
| CI workflow | remote sensor running the same gate |
| spec flow (the saddle's own) | intent → reviewed spec → plan → feature_list |
| `docs/saddle/{discovery,design,report}.md` | the install's own audit trail |
