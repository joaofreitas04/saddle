# Phase 2 — Context interview

Ask one question at a time; each answer may make later questions unnecessary.
Never ask what discovery already answered — asking a human something the repo
could tell you burns the trust this workflow runs on. Time box: this phase is
worth ~5–10 focused questions, not an interrogation.

## Question bank (in leverage order)

1. **Invariants.** "What must an agent NEVER do in this repo?" (files/dirs not
   to touch, forbidden dependencies, data rules, deploy actions). These become
   Golden Rules and, where possible, mechanical checks — a rule that matters
   deserves a gate, not just a sentence.
2. **Protected paths & credentials.** Where do secrets live, which
   environments are reachable from a dev checkout, is there anything a
   full-speed agent could damage? (Feeds AGENTS.md rule 4 and the sandbox
   recommendation.)
3. **Definition of done.** "When YOU say a change is done, what did you run or
   check?" Anything mentioned that isn't in `verify` yet is a gap to close or
   record.
4. **Current goals.** The next 3–5 concrete things they want built/fixed —
   these seed `feature_list.json` with real entries instead of examples.
5. **Autonomy appetite.** Watch every session (A1), review PRs only (A2), or
   comfortable with unattended one-shots (A3) once the gate holds? Sets the
   report card's target rung.
6. **Review workflow.** Who merges? Any CI requirements already mandatory?
   (Feeds the CI mirror and PR conventions.)
7. **Tribal conventions.** "What do new contributors always get wrong here?"
   — the highest-value AGENTS.md lines come from this question.
8. **Test philosophy** (only if discovery found gaps): is adding
   characterization tests around hot areas acceptable as the first agent
   campaign?
9. **Work tracking.** Where does work live — Jira, Linear, GitHub Issues, or
   the local feature list? Which project/board, and which EXISTING
   templates, statuses, and labels must agents respect (never invent a
   parallel taxonomy)? Who on the team has/needs a personal connection?
   (Feeds the three-layer tracker contract — references/trackers.md.
   Unattended default: local feature_list.json is truth.)
10. **Monorepo placement** (only if discovery found workspace signals):
   install at the root (one gate that fans out per workspace) or per
   package? Unattended default: root install — root AGENTS.md + verify
   delegating to workspace commands, nested AGENTS.md files added later
   where packages diverge.

Done when: every item in discovery's "Risks & unknowns" list is answered,
defaulted, or escalated (questionnaire). Answers land in the design doc —
a "Decisions from interview" list feeding its sections — not in chat alone.

## Interview discipline

- **Facts vs decisions.** If a fact can be found by exploring the environment
  (filesystem, git, configs, the web), look it up — never ask. Decisions
  belong to the human: put each one to them and wait. Never park a lookupable
  fact as a question; never self-answer a decision.
- **Every question ships with your recommended answer**, so the human can
  accept in a word. Live sessions: one question at a time (multiple at once
  is bewildering).
- **Async or follow-up rounds: batch the frontier.** Present every question
  whose prerequisites are already settled as one numbered round (each with a
  recommended answer); hold dependent questions for the next round; run
  fact-finding lookups concurrently while you wait.
- **Absent stakeholder escalation.** When a decision belongs to someone who
  isn't the operator (security, product, another team), emit a questionnaire
  artifact instead of stalling or guessing: questions most-important-first
  (async means you may only get one pass), one idea per question, an answer
  stub under each, deadline + expected effort, partial answers legitimized.
  A later session parses the answers back in.

## Unattended defaults

When no human is available, apply these and log each as an assumption in
`docs/saddle/design.md`:

| Topic | Default |
|---|---|
| Invariants | No force-push; no deleting/weakening tests (always); don't touch CI secrets, deploy configs, or dotenv files |
| Protected paths | `.env*`, `**/secrets*`, deploy/infra dirs — read-only until a human says otherwise |
| Done | `scripts/verify` green + feature steps executed |
| Goals | Seed feature_list with: (1) verify-gate hardening gaps found in discovery, (2) characterization tests for the most-imported module, (3) one README/AGENTS accuracy pass |
| Autonomy target | A2 (delegated tasks, PR review) — never assume A3+ |
| Review | Human merges; agent self-review note in PR description |
| Conventions | Infer from the code; encode only patterns observed ≥3 times |

Rule of honesty: an assumption is a debt. Every applied default appears in the
design doc's Assumptions section AND in the final report, so the first human
review can repay them cheaply.
