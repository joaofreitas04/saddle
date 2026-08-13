---
name: saddle-session
description: Run one saddle work session in this repo — orient, baseline green, pick ONE frontier item, implement, verify with evidence, record. Start every working session by invoking this.
disable-model-invocation: true
---

# saddle-session — one unit of trustworthy work

The repo's files own every rule; this command loads the discipline at the
moment of use. Never restate what a file says — read it.

1. **Orient.** Read `AGENTS.md`, `git log --oneline -15`, `progress.md`
   (tail), `session-handoff.md` (especially Suggested next invocations).
2. **Baseline.** `./init.sh` then `./scripts/verify`. Green before anything
   changes; if red, fixing that IS the session.
3. **Select ONE.** The assigned task, or the highest-priority FRONTIER entry
   in `feature_list.json` (`passes:false`, all `blocked_by` passed; array
   order = priority). Parallel sessions: set `claimed_by` BEFORE working.
4. **Implement** the smallest change satisfying the entry's done-criteria.
   Cadence: typecheck continuously, targeted tests frequently, the full gate
   once at the end. Out-of-scope discoveries become NEW entries — never
   silent diff expansion.
5. **Verify with evidence.** `./scripts/verify` plus the entry's own steps,
   end-to-end as a user would. Red = stop-and-fix; never weaken a check or
   test to pass (see AGENTS.md golden rule 1).
6. **Record.** Descriptive commit; one-line `progress.md` entry with
   pointers; update `session-handoff.md` (reference, don't duplicate); flip
   `passes` only after step 5 actually ran; append any non-obvious
   dependency lesson to its `docs/kb/` card.

Redaction rule throughout: any command output or artifact you record gets
secrets redacted FIRST — write `<REDACTED>`, keep credentials in env vars
so they never enter the transcript, quote only signal-carrying lines.

7. **Exit by the tree.** At the session's end (a phase boundary — the only
   place this decision belongs), take the FIRST yes:
   1. Next work needs THIS session's reasoning verbatim, and window room
      remains? → continue here.
   2. Everything here disposable? → clear; state files carry the baton.
   3. Moving harness/directory, or handing to a colleague? → handoff file.
   4. Next task tightly scoped and steerable-free? → subagent, report back.
   5. Otherwise → compact WITH an instruction naming what the next phase
      needs. Compact is the default, not the first reach — a summary
      flattens decisions, and a fresh session confidently wrong about one
      is the failure mode.

Done when: the entry's steps all executed green, the gate is green, and a
cold reader could resume from the state files alone.
