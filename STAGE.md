# Project Stage

> Single-glance answer to "which WORKFLOW.md stage is this repo at?"
> Template: `docs/templates/STAGE.md`. Rule: `docs/decisions/0013-self-review-lane-and-stage-tracker.md`.

## Snapshot

- **Lane:** N/A — this is the harness source repo, not a project using the harness
- **Current stage:** Meta — harness self-development
- **Last completed:** harness v0 baseline (commit `4f03e7d` — 2026-05-17 auto-commit on bootstrap + stage boundary commit rule)
- **Next gate:** none — harness work is tracked in `docs/HARNESS_BACKLOG.md` + `plans/`
- **Blockers:** none
- **Updated:** 2026-05-18 by author

## Why This Repo Is Special

This repo (`harness-experimental`) ships the harness itself. The 13-stage WORKFLOW.md flow applies to **projects bootstrapped from this harness** (via `scripts/install-harness.sh --bootstrap`), not to harness development itself.

For harness development:

- Backlog: `docs/HARNESS_BACKLOG.md`
- Plans: `plans/<YYMMDD-HHMM>-<slug>/`
- Decisions: `docs/decisions/NNNN-*.md`
- Stage boundary commit rule (decision 0012) still applies when shipping a stage-shaped harness change (e.g. adding a new stage to WORKFLOW.md = one bundled commit).

## What Projects Get

When a project runs `install-harness.sh`, the installer ships `docs/templates/STAGE.md` as the canonical template. The project's first commit (bootstrap baseline) copies the template to repo root and fills the Snapshot section. Each stage boundary commit thereafter moves one row from Pending to History and updates Snapshot.

## Pointers

- Template: `docs/templates/STAGE.md`
- Lane definitions: `docs/FEATURE_INTAKE.md` § Lanes
- Stage map: `docs/WORKFLOW.md`
- Update rule: `docs/decisions/0013-self-review-lane-and-stage-tracker.md`
- Commit rule: `docs/decisions/0012-stage-boundary-commits.md`
