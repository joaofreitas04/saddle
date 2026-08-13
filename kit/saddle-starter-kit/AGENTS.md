# {{PROJECT_NAME}}

{{ONE_SENTENCE_DESCRIPTION}}. This file is the entry point for AI agents.
Keep it short, stable, and current — details live in the linked docs.

## Golden rules

1. NEVER remove, weaken, or edit tests to make checks pass. It is unacceptable
   to remove or edit tests because this could lead to missing or buggy
   functionality. If a test seems wrong, stop and flag it in progress.md.
2. `./scripts/verify` green is the definition of done. Red verify = stop and
   fix before anything else. Never proceed past a failing check.
3. One feature/task per session. File out-of-scope findings as new
   feature_list.json entries or issues — do not expand the current diff.
4. Do not commit secrets, `.env` files, or credentials. Do not touch
   {{PROTECTED_PATHS}} without being explicitly asked.
5. Evidence, not assertions: a feature's "passes" flips to true only after you
   ran its steps and they succeeded. Say what you ran and show the output.
6. {{PROJECT_SPECIFIC_INVARIANT}}

## Commands

| Purpose | Command |
|---|---|
| Environment up + health check | `./init.sh` |
| Definition of done | `./scripts/verify` |
| Fast subset (pre-commit) | `./scripts/verify fast` |
| Run the app | `{{RUN_CMD}}` |

## Session protocol

1. Orient: read this file, `git log --oneline -15`, `progress.md` (tail),
   `session-handoff.md`.
2. Baseline: run `./init.sh`, then `./scripts/verify`. The world must be green
   before you change it. If it isn't, fixing that IS the session.
3. Select ONE item: the assigned task, or the highest-priority FRONTIER
   entry in `feature_list.json` (`"passes": false` AND every `blocked_by`
   entry already passed; array order = priority).
4. Implement the smallest change that satisfies its done-criteria.
5. Verify: `./scripts/verify` plus the feature's own steps (end-to-end, as a
   user would — not unit tests alone).
6. Record: descriptive commit; append a progress.md entry; update
   session-handoff.md; flip `"passes"` only per rule 5; learned something
   non-obvious about a dependency or convention? Append it to the matching
   `docs/kb/` card.

## Architecture (orientation map)

- {{KEY_DIRECTORY_1}} — {{WHAT_LIVES_THERE}}
- {{KEY_DIRECTORY_2}} — {{WHAT_LIVES_THERE}}
- {{ARCHITECTURE_RULE}} (enforced by {{STRUCTURAL_TEST_OR_LINT}} — do not
  work around it)

## Conventions

- {{STYLE_CONVENTION}}
- {{NAMING_CONVENTION}}
- Commits: imperative subject, body explains why. Small and frequent, only on
  green.

## Where things live

| Need | File |
|---|---|
| What to build & done-criteria | `feature_list.json`, `specs/` |
| What happened so far | `progress.md` |
| Resume state | `session-handoff.md` |
| Deep docs | {{DOCS_DIR_OR_LINKS}} |

<!-- Maintenance: this file stays ~1 page and byte-stable during sessions.
     Add a line only when its absence caused a real mistake; remove lines
     that stopped earning their place. -->
