# Work tracking: the three-layer approach

Teams differ in tool (Jira, Linear, GitHub Issues, local files), every tool
has its own MCP/CLI, and connections are usually *personal* (each user's
token or OAuth grant) — while templates, statuses, labels, and versioning
are *team* standards. The saddle survives all of that by separating three
layers that change at different speeds and belong to different owners.

## Layer 1 — Team contract (versioned in repo; person-independent)

Generated in Phase 4 as `docs/agents/tracker.md` from the Phase 2 interview.
It contains, concretely:

- **Canonical states** and their mapping to the tool's real workflow states,
  with the invariant "every item carries exactly one state."
- **Issue templates** — the agent-brief shape with the durability doctrine
  baked in: behavioral contract + interface names, no file paths or line
  numbers, independently verifiable acceptance criteria, an out-of-scope
  section.
- **Label taxonomy**, including the dispatch signal (`ready-for-agent` or
  the team's equivalent — agents never pick up un-triaged work) and
  needs-info / wontfix conventions.
- **Versioning conventions**: fix-versions/releases, naming, how issues link
  to changelog entries.
- **Linking rules**: blocked-by relations, PR↔issue linking, commit-message
  references.
- **Comment conventions**: agent comments open with an AI-disclaimer line;
  "done" comments attach verify evidence (command + result), not claims.
- **The canonical verbs table** — the only interface the rest of the saddle
  uses: `publish`, `fetch`, `claim`, `resolve`, `block`, `query-frontier`.
  Each verb row gives the tool-specific implementation (the JQL for
  frontier, the API/MCP/CLI call shape). AGENTS.md and skills speak verbs
  only; migrating tools rewrites this one document.

## Layer 2 — Tool binding (team-chosen, repo-declared, secret-free)

In the same doc: which tool, which project key / board / team id, and the
access path by *name* (an MCP server name, a CLI, REST). Never a token,
never a URL with credentials.

## Layer 3 — Personal capability (per-user; never in the repo)

The MCP connection / token / OAuth grant belongs to each human and each
agent runtime. Rules:

- **Detect, don't configure.** Preflight and init probe with one cheap read
  (fetch one issue, or the API's whoami). Present → tracker mode.
- **Guide, don't block.** Absent → emit the personal connection checklist
  (which console to visit, which scopes, where the host stores the secret) —
  for multi-step token ceremonies, generate a wizard script with confirm
  gates and idempotent re-runs rather than a prose TODO. Then continue in
  local mode; a teammate without a token still gets a working saddle.
- **Graceful sync.** Work created offline is marked sync-pending and
  published on the next connected session.
- **Credential hygiene**: tokens live in the host's secret store or
  environment, never in repo files; agents invoke the capability and never
  read or echo the secret. (MCP's 2025 auth revisions — browser-side
  credential elicitation, URL-based client identities — are making exactly
  this per-user leg cleaner; prefer those flows where the tool offers them.)

## The one-source-of-truth rule

Exactly one of these, chosen in Phase 3 and recorded in the contract doc and
AGENTS.md routing:

- **Tracker is truth** — `feature_list.json` becomes a generated read-only
  view (or is retired); the frontier is a saved query; progress comments
  live on issues, `progress.md` keeps one-line pointers.
- **Local is truth** — no tracker, or solo work: `feature_list.json` as
  shipped, tracker optional later.

Never both. Parallel truths drift within a week, and agents trust whichever
they read last.

## Schema mapping (when tracker is truth)

| Saddle concept | Tracker concept |
|---|---|
| feature_list entry | issue with the agent-brief template |
| `"passes": false` | open / not-done state |
| `blocked_by` | native blocking links |
| the frontier | saved query: ready-for-agent ∧ no open blockers |
| progress.md entry | issue comment with verify evidence (+ one-line local pointer) |
| session-handoff.md | stays in repo — session state, not work state |
| specs/, docs/kb | stay in repo — versioned knowledge, not work items |

## Install path

Phase 2 asks where work lives and which existing templates/states/labels
must be respected (never invent a parallel taxonomy where one exists).
Phase 3's design doc carries the Work-tracking plan (binding,
source-of-truth choice, contract summary, per-user connection status).
Phase 4 writes the contract doc and wires the AGENTS.md routing line
("publishing or picking up work? read docs/agents/tracker.md first").
Phase 5 validates by probe: one read; plus one write-then-cleanup canary
(a comment or sandbox issue) where the team allows it — otherwise mark
"write path: statically verified only," honestly.
