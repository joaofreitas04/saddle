# saddle-up

**Turn any repository into a proven environment where agents implement and
humans steer.**

**Saddle** is the friendly agent harness. One skill — `saddle-up` — that
installs, audits, or upgrades everything a repo needs for trustworthy
autonomous work: a teeth-proven verify gate, environment bootstrap,
spec-driven scope with machine-checkable done-criteria, cross-session state
files, a live-probed knowledge base, an optional issue-tracker contract
(Jira/Linear/GitHub), three committed operating commands
(`saddle-session`, `saddle-spec`, `saddle-check`), and a report card that
scores how much of your development lifecycle now runs agent-side. Then —
before calling anything done — it tries to break what it built.

## Install

**As a Claude Code plugin** (recommended — receives updates):
```
/plugin marketplace add joaofreitas04/saddle
/plugin install saddle-up@saddle
```

**Via the open skills ecosystem** (70+ agents — Claude Code, Codex, Cursor,
Copilot, ...):
```
npx skills add joaofreitas04/saddle
```

**No skills support at all?** `kit/INSTALL_PROMPT.md` is the same workflow
as a paste-anywhere prompt, and `kit/saddle-starter-kit/` holds the raw
templates.

Then, in any repo: *"Install the saddle"* / *"Make this repo agent-ready"*
/ *"Audit our saddle."*

## What a run produces

| Artifact | Purpose |
|---|---|
| `AGENTS.md` (+`CLAUDE.md` import) | contract: golden rules, session protocol, routing |
| `init.sh` | environment bring-up + health check |
| `scripts/verify` | THE definition of done — fail-fast, pipefail, fast/full tiers |
| `feature_list.json`, `specs/` | frontier-scheduled scope with EARS done-criteria |
| `progress.md`, `session-handoff.md` | cross-session state (index-not-store discipline) |
| `docs/kb/` | dependency cards with **live-probed** llms.txt/docs-MCP sources, conventions glossary, ADRs, out-of-scope store |
| `docs/agents/tracker.md` (optional) | team tracker contract: states, templates, canonical verbs |
| CI workflow | the same gate, remotely |
| `docs/saddle/{discovery,design,report}.md` | the install's own audit trail |

The workflow: **preflight → evidence-based discovery (repo treated as
untrusted) → interview (facts looked up, decisions asked) → design under a
human gate → install → validation → report card.** Validation is the
signature move: inject a failing test and a broken source file and require
the gate to go RED (then green again); cold-start a fresh session from repo
files alone; probe every claimed capability. A gate that cannot fail is
worse than none.

## Measured, not vibed

Benchmark (fresh-context agents, objective per-run assertions, baseline =
same model without the skill):

| Fixture | with skill | baseline |
|---|---|---|
| Node library, full install | 11/11 | 7/11 |
| Python library, zero tests, unattended | 11/11 | 6/11 |
| React app incl. knowledge base + spec flow (demo) | all phases, 3 red canaries, cold-start pass | — |

Baselines build decent verification but skip cross-session state, scope
tracking, audit trails, and branch discipline — and commit straight to main.
Every capability the skill claims is proved at install time, and hardened by
adversarial review, before it earns trust.

## Design commitments

The skill ships **method, never facts that rot**: docs sources are resolved
from registry metadata and probed live at install time; marketplace skills
are searched and vetted live; nothing stack-specific is hardcoded. Every
change is reasoned and versioned. Unattended runs never install third-party
code and never pass the design gate without prior end-to-end authorization.

## Repo layout

```
skills/saddle-up/   the skill (SKILL.md + phase references + scripts + templates)
kit/                standalone templates + universal INSTALL_PROMPT
.claude-plugin/     plugin + marketplace manifests
```

MIT.
