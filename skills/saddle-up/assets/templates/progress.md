# Progress log

Append-only. One entry per session, newest at the bottom. Never rewrite
history — this file is how the next session (and the humans) reconstruct what
happened without replaying transcripts.

This log is an index, not a store: one line per outcome plus a pointer
(commit hash, spec path, kb card) — detail lives at the source. Re-read the
file from disk before appending; humans may have edited between sessions.

Entry format:

```
## YYYY-MM-DD HH:MM — <agent/human> — <feature id or task>
- Did: <what actually changed, 1-3 lines>
- Verified: <what was run and its result — commands, not vibes>
- Decisions: <choices made and why, if any>
- Follow-ups filed: <new feature_list/issue entries created, if any>
- Commit: <hash> <subject>
```

---

## (entries begin below)
