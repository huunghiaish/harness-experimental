# Plan B — Lifecycle Gates + Installer Marker-Preserve

**Date:** 2026-05-17 · **Branch:** main · **Status:** Awaiting trigger (per decision 0005)

## Goal

Land production-readiness + hypercare playbooks, the high-risk story
template line that pulls prod-readiness in automatically, and the installer
behaviour that preserves `HARNESS:EXT` marker blocks across overrides.

## Triggers (per decision 0005 § 3)

Execute Plan B when EITHER fires:

1. First project ships a release through `install-harness.sh --override` or
   `--merge` with `HARNESS:EXT` blocks present (installer marker preservation
   becomes load-bearing).
2. First high-risk story moves toward production deploy (prod-readiness
   checklist becomes load-bearing).

Until one of these fires, Plan B is documented intent, not active work.
`docs/playbooks/PATCH-EXTENSION-PROTOCOL.md` records the honour-system gap
explicitly.

## Source Context

- `docs/decisions/0004-adopt-claudekit-custom-patterns.md` § Decision item 3
  + closed sub-decisions on installer behaviour.
- `docs/decisions/0005-roadmap-execution-direction.md` § 3 (B triggers) and
  § 2 (C before B priority).
- `plans/reports/roadmap-260517-1234-claudekit-custom-port-roadmap.md` —
  Plan B scope detail.
- `plans/reports/xia-260517-1130-claudekit-custom-skill-scan.md` — Tier S6
  + Tier B4 source analysis.

## Phases (drafted at trigger time)

Phase file detail intentionally deferred per decision 0005 § Alternatives 3.
Sketch below is for visibility, not for direct execution.

| # | Phase | Output (sketch) |
|---|-------|-----------------|
| 1 | Production-readiness checklist playbook | `docs/playbooks/production-readiness-checklist.md` — pre-ship checklist (security, backup, rollback, DNS, SSL, monitoring). Each row cites a TC token where possible. |
| 2 | Hypercare plan playbook | `docs/playbooks/hypercare-plan.md` — post-go-live support shape (incident process, escalation, rotation, retro hook). |
| 3 | High-risk story template line | `docs/templates/high-risk-story/execplan.md` — add one required line: "If this story moves to production, link to `production-readiness-checklist` playbook before merge." |
| 4 | Installer marker-preserve + test | `scripts/install-harness.sh` updated to preserve `HARNESS:EXT:START/END` blocks on `--override` and `--merge`. New shell test: `scripts/test-install-marker-preserve.sh`. |

**Estimated effort when work begins:** ~4-6h.

## Dependencies

- Plan A complete (uses `HARNESS:EXT` marker contract).
- Decision 0004 + 0005 accepted.
- Independent of Plan C / D / E execution status.

## Risk

Normal. Phases 1-3 are docs-only (tiny). Phase 4 changes installer behaviour
contract (normal) — adds a test fixture; rollback = revert installer change.

## Success Criteria (will apply when triggered)

- `docs/playbooks/production-readiness-checklist.md` exists, registered in
  `docs/playbooks/README.md` under "Workflow recipe".
- `docs/playbooks/hypercare-plan.md` exists, registered.
- `docs/templates/high-risk-story/execplan.md` references prod-readiness
  playbook in the documented one-line form.
- `scripts/install-harness.sh` passes the new marker-preserve test in CI
  (or via manual run of the test script if no CI).
- `docs/playbooks/PATCH-EXTENSION-PROTOCOL.md` § "A future harness installer
  pass (Plan B) will preserve this block..." paragraph is updated from
  promise to fact.

## Out Of Scope

- Code review scoring (Plan D).
- E2E flow + seed pattern (Plan D).
- Project closure story (Plan D).
- Any external comms integration (Slack / Telegram / email — org concern).
- Hypercare engagement model (org concern; playbook is a shape, not a
  service contract).

## Trigger Watchlist

Re-check these signals when working in the harness:

- New stories landing with deploy intent — check execplan.md against this
  plan.
- Anyone running `install-harness.sh --override` on a project with
  `HARNESS:EXT` blocks — promote Plan B immediately to avoid lost work.

When a trigger fires, drop phase files into this directory and mark plan
status as `in execution`.

## Trigger Evaluations

| Date | Trigger 1 (installer + HARNESS:EXT in target project) | Trigger 2 (high-risk story → production) | Outcome |
|------|---|---|---|
| 2026-05-17 | NOT fired. `HARNESS:EXT:START` matches in this repo are documentation examples inside code fences within `docs/playbooks/PATCH-EXTENSION-PROTOCOL.md`. No TARGET project has installed the harness and added real extension blocks yet. | NOT fired. No `execplan.md` / `overview.md` files exist under `docs/stories/`. No story file contains "production", "deploy", "go-live", "ship", or "hypercare". Only story is `US-001-install-harness.md` (harness bootstrap, not product deploy). | Awaiting trigger. No phase drafting or execution performed. |

## Unresolved Questions

1. When triggered: should phase 4 (installer change) ship alongside phases
   1-3 (docs) in one PR, or land independently? Recommend independent —
   installer is normal-risk and benefits from its own review.
2. Hypercare retro hook: does the harness define a retro template, or rely
   on team's existing retro process? Recommend rely on team (out of scope
   for harness mission).
