# Changelog — saddle-up

User-facing summary of what each release changed. Newest first.

## v2.14
- The skill now speaks only about its own solution: removed references to
  external spec/workflow tools as alternatives, examples, or citations.
  Ecosystem install tooling (`npx skills`, the MCP registry, Context7) is
  unchanged.

## v2.13
- **The Saddle Score**: a published readiness number (coverage + gate-teeth
  freshness + autonomy rung + state freshness), recomputed by every
  `saddle-check` and written to a score file plus a README badge.
- `saddle-session` gained a phase-boundary exit routine for clean context
  hand-offs between work phases.
- Transcript redaction is now standard in `saddle-session`, `saddle-check`, and
  validation evidence — secrets are never recorded.

## v2.12
- Renamed to **saddle-up**; operating commands are `saddle-session` /
  `saddle-spec` / `saddle-check`; work happens on a `saddle/init` branch with an
  install audit trail under `docs/saddle/`.

## v2.11
- Shipped Claude-native trust templates: `.claude/settings.json`, a PreToolUse
  protect hook, and a clean-context reviewer subagent. Added Codex parity
  metadata (`agents/openai.yaml`) on the installer and every minted skill.

## v2.10
- The installer now mints three committed operating commands into the target
  repo (`saddle-session` / `saddle-spec` / `saddle-check`) that load the repo's
  own rules rather than restating them.

## v2.9
- Added this changelog and formalized invocation governance for minted skills
  (user-invoked vs model-invoked).

## v2.8
- Hardened by a constraint-diverse adversarial review. Highlights: the verify
  gate gained `pipefail` and mode validation; discovery now treats the repo as
  untrusted (side-effect screen + containment before running any command); docs
  resolution pins the public registry; unified unattended design-gate and
  work-selection rules; monorepo / non-GitHub-CI / no-test / slow-suite
  handling added.

## v2.7
- Work tracking as a three-layer contract: in-repo team standards, secret-free
  tool binding, and personal tracker connections detected (not configured) with
  a graceful local fallback.

## v2.6
- Adopted field-tested disciplines: facts-vs-decisions interview, frontier +
  `blocked_by` + claim-before-work scheduling, tracer-bullet slicing, durability
  doctrine (no paths / line numbers in long-lived artifacts), and an
  out-of-scope rejection store.

## v2.5
- The autonomy-coverage mandate: score which lifecycle operations run
  agent-side (✅/🟡/⛔), name every gap's blocker, and publish it as tracked work.

## v2.4
- `find-skills` proposed as a standing capability-discovery skill; overlap
  guardrails for marketplace installs.

## v2.3
- Marketplace search + project-scope install via `npx skills` (70+ agent
  targets); popularity signals feed but never replace vetting.

## v2.2
- Stack knowledge became live-by-construction: registry-metadata docs
  resolution + llms.txt probing + marketplace survey. The skill ships method,
  not stack facts that go stale.

## v2.1
- Spec-driven flow rebuilt from primary sources: scale-matching table, EARS
  done-criteria, review-burden caps, "specs steer, gates enforce."

## v2.0
- Knowledge base (router + probed dependency cards), spec-driven flow, and
  framework detection.

## v1.0
- Initial skill: phases 0–6, evidence-based discovery, design gate, templates,
  gate-teeth canaries, cold-start test, report card.
