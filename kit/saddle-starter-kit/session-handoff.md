# Session handoff

Overwritten at the END of every session. Optimize for a cold start: the next
reader has zero memory of this session. (progress.md keeps history; this file
keeps only the resume state.)

## Current state
<!-- One paragraph: where the work stands right now. Is verify green? -->

## Next step
<!-- The single most important thing to do next, concretely. Which
     feature_list.json id, and where to start in the code. -->

## In-flight / uncommitted
<!-- Branches, stashes, half-done migrations. "None" is a great answer. -->

## Blockers
<!-- Anything that stopped progress, with what was already tried. -->

## Watch-outs
<!-- Landmines the next session should know: flaky test X, module Y is
     load-bearing and fragile, don't upgrade Z yet, etc. -->

## Suggested next invocations
<!-- What the next session should reach for: which feature id, which skill
     or flow, which docs to read first. -->

<!-- Discipline: reference, don't duplicate — link specs, progress entries,
     commits, and kb cards by path; restate nothing they already say. This
     file is the conversation squeezed to its resumable core. -->
