# Phase 1 — Discovery

Goal: a discovery report so grounded that the design phase contains zero
guesses. Everything the saddle will later claim ("run X to test") must be
*observed working* here, because a saddle that lies about commands teaches
agents to distrust or bypass it.

## Procedure

1. **Deterministic sweep.** Run `scripts/detect_stack.sh <root>` and keep the
   output. It reports ecosystems, package managers, monorepo signals, declared
   scripts/targets, test-file counts, CI, containers, and pre-existing saddle
   artifacts.

2. **Execute the candidate commands — contained, and screened first.** The
   repo is UNTRUSTED at this point: its package scripts, Makefile targets,
   and install hooks are arbitrary code. Before running anything: (a) read
   each candidate command and its script definition; anything with network
   egress, deploy/publish verbs, database access, or suspicious postinstall
   hooks gets deferred until after the interview or run only inside a
   sandbox; (b) run everything inside the strongest containment available
   (srt / container / the host's sandbox mode — see the containment ladder
   in the safety layer); prefer install flags that skip lifecycle scripts on
   the first pass (e.g. `npm ci --ignore-scripts`) and note if the real
   install then differs. Then: run each safe candidate, record exit code,
   wall time, and a one-line result. These measured facts decide the verify
   tiers — anything ≥ ~30s cannot live in the fast tier; flakiness gets
   flagged now. For very slow suites, run once, label the timing "measured
   once", and don't repeat — honesty over repetition.

3. **Test reality check.** Test *files* existing ≠ tests running. Run the
   suite; record count passed/failed/skipped and runtime. If there are no
   tests, say so plainly — Phase 3 must design around it (smoke test now +
   characterization-test backlog), never paper over it.

4. **Architecture walk.** Skim entry points, directory roles, and the
   dependency direction. You need enough to write the 5–10 line orientation
   map in AGENTS.md and to spot one enforceable architecture rule (if an
   obvious one exists). Note conventions the code exhibits (naming, error
   handling, layering) — these become AGENTS.md lines only if deviation would
   cause real mistakes.

5. **Context sources.** README/docs quality, existing CI gates (what already
   blocks a merge?), .env.example / secret patterns (what must the saddle
   protect?), services needed to run (DB, queues — what must init.sh start or
   stub?). Note the CI system (only GitHub Actions has a shipped template —
   other CI gets a verify job merged into its EXISTING config) and whether
   development is Windows-primary without WSL — a bash-based gate then needs
   an explicit design decision, flagged in the report.

6. **Existing saddle inventory** (upgrade mode): list each artifact found and
   a one-line judgment (current / stale / conflicting), to be graded against
   the report card in Phase 6.

## Report template — write to `docs/saddle/discovery.md`

```markdown
# Saddle discovery — <repo> — <date>

## Stack
Ecosystems, package manager(s), monorepo layout (from detect + confirmation).

## Verified commands
| Purpose | Command | Exit | Time | Notes |
(one row per command actually executed — including failures)

## Tests reality
Suite runner, counts, runtime, flakiness observed, coverage of what matters.
"No tests" is a valid, important finding.

## Architecture orientation
5–10 lines: entry points, key directories, dependency direction, one
enforceable rule candidate.

## Services & environment
What must run for the app to work; env vars/secrets shape; how CI does it.

## Existing gates & saddle artifacts
What already blocks merges; agent files already present and their state.

## Risks & unknowns for the interview
Numbered list — these become the Phase 2 questions.
```

Keep it under ~120 lines. The report is itself a saddle artifact: the next
agent that touches this repo cold-starts from it.
