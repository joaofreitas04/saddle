# Knowledge base construction (L9)

Installed during Phase 4, planned during Phase 3. The knowledge base is how
the saddle gives agents *stack understanding*, not just process. Design rule:
the KB is a **router plus small cards**, never a docs dump — vendoring whole
documentation into the repo buys staleness and context tax; the win is knowing
*where truth lives* and what this repo has *already learned*.

## Structure

```
docs/kb/
  README.md          # the router: doubt → file, plus maintenance rules
  stack/<dep>.md     # one card per LOAD-BEARING dependency only
  conventions.md     # glossary of THIS codebase's terms + observed patterns
  decisions.md       # ADR-lite: dated decisions + why
  out-of-scope/      # one file per REJECTED concept (negative knowledge)
docs/saddle/        # install audit trail (discovery/design/report)
harness-llms.txt     # optional meta-KB: harness-engineering learnings (industry term)
```

## Curation disciplines (adopted from working suites)

- **Glossary format** for conventions.md: `**Term**: definition` plus an
  `_Avoid_:` list of banned synonyms, and a "Flagged ambiguities" ledger
  recording term conflicts and their resolutions. Be opinionated — one
  canonical word per concept.
- **ADR gate:** record a decision only when it is hard to reverse AND
  surprising without context AND involved a real trade-off. One paragraph is
  enough. Include rejected alternatives when the rejection is non-obvious —
  otherwise someone re-suggests them in six months. Capture inline as
  decisions land; never batch.
- **The out-of-scope store:** one file per rejected concept with the
  reasoning and links to the requests it closes. Intake (triage, specs, new
  feature_list entries) checks candidates against it BY CONCEPT, not
  wording. Poisoning rule: things that were BUILT never enter it — only
  genuine rejections — or the dedup check rots.
- **Shared-file write discipline:** re-read any human-shared state file from
  disk before writing (humans edit between turns); supersede records instead
  of deleting them.
- **Research ingestion bar:** background research lands as a cited kb file —
  primary sources only, and follow every claim back to the source that owns
  it. Uncited claims don't enter the KB.

Card selection rule: framework, build tool, test runner, plus the top ~3
libraries by import count — typically 4–7 cards total. Not the whole lockfile.

## Card template (`docs/kb/stack/<dep>.md`, ≤1 page each)

```markdown
# <dep> — v<installed version> (from lockfile)

## Role in this repo
2–3 lines: what it does here, where it's configured.

## Authoritative docs
- Official docs: <url>
- llms.txt: <url> (verified <date>) — or "none published as of <date>"
- Docs MCP: <e.g. Context7 library id, if such a server is available>

## How this repo uses it
Entry points, config files, patterns to follow (point at real files).

## Gotchas observed here (append-only)
- <date> <one-line lesson learned in a real session>

## Re-check docs when…
Version bump past <major>, or touching <the risky area>.
```

## Source hierarchy (in trust order)

1. **This repo** — code, configs, git history. Always first.
2. **Official llms.txt** — the llmstxt.org convention (Markdown index at
   `/llms.txt`, sometimes `llms-full.txt`, sometimes version-stamped with a
   `@doc-version`). Coverage is real but uneven and shifts month to month, so
   **probe live, never assume and never trust remembered tables**: resolve
   each dep's docs domain from registry metadata and probe it
   (`references/stack-intel.md` Part 1; `scripts/resolve_docs.sh` emits the
   candidates). Record the result (URL + verified date, or "none as of
   <date>") in the card. Store URLs, not copies.
3. **Docs MCPs** (Context7 and similar, when connected): best for
   version-specific API questions at task time — prefer a live query over a
   stale local note; record the library id in the card so future sessions
   query instead of guessing.
4. **Pinned local extracts** — only for airgapped CI or a hard version freeze,
   and only the minimal distilled section, marked with its source and date.

## Wiring into the saddle

- AGENTS.md gets routing lines, not content: "Touching <framework> code? Read
  `docs/kb/stack/<framework>.md` first. New non-obvious lesson about a dep?
  Append it to that dep's card." (This is the continual-learning loop — the KB
  grows one verified lesson at a time, exactly like a harness-llms.txt.)
- The session protocol's record step includes the append rule above.
- feature_list gets a low-priority recurring entry: "KB freshness pass —
  re-probe llms.txt URLs and versions" so links don't rot silently.
- Optional CI: a link checker over docs/kb (suggest, don't block).

## Skills and MCP wiring (capability layer)

1. **Discover and vet live** via the stack-intelligence procedure
   (`references/stack-intel.md` Part 2): inventory what the host already
   has, search the official and open marketplaces with stack keywords, vet
   by provenance / freshness / read-every-script, and install approved
   matches **pinned, at project scope** so the repo carries them for every
   agent and teammate (unattended: recommend-only, never install
   third-party code without a human yes).
2. **Mint project skills from repetition.** Where no vetted match exists,
   the first procedure explained or performed twice (e.g. "add a component
   with test + story") becomes `.claude/skills/<name>/SKILL.md` (or the
   host's equivalent), following the open Agent Skills format: name +
   description frontmatter, ≤1-page body, scripts for the deterministic
   parts. Govern invocation deliberately: decide user-invoked
   (orchestration, reachable only when a human types it) vs model-invoked
   (reusable discipline) by the test "could the model usefully reach for
   this autonomously?" — and when a workflow needs both, make the entry
   point a one-line wrapper over a model-invoked primitive. Note each
   minted or installed skill in `docs/kb/README.md` so it's discoverable
   across tools.

## What NOT to do

Do not copy framework tutorials into the repo. Do not create cards for every
dependency. Do not let the KB replace AGENTS.md (contract) or specs (intent) —
it holds *facts and lessons about the stack and this codebase*, nothing else.
If a card exceeds a page, the overflow is probably conventions.md or
decisions.md material.
