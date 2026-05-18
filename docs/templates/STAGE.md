# Project Stage

> Single-glance answer to "which WORKFLOW.md stage is this repo at?"
> Updated at every stage boundary commit per `docs/decisions/0013-self-review-lane-and-stage-tracker.md`.
> One-line `cat STAGE.md` (or scroll through History) tells you what to pick up next.

## Snapshot

- **Lane:** self-review (default) | tiny | normal | high-risk
- **Current stage:** N — <stage name>
- **Last completed:** N-1 — <stage name> on YYYY-MM-DD (commit <short-sha>)
- **Next gate:** <one-line — what unlocks moving to the next stage>
- **Blockers:** <none | description>
- **Updated:** YYYY-MM-DD by <author / agent>

## How To Use

1. Returning to this project after time away? Read this file first.
2. About to start work? Verify Current stage matches what you intend to do.
3. Completing a stage? Move the row from Pending to History, update Snapshot, then commit STAGE.md as part of the stage boundary commit (per `docs/decisions/0012-stage-boundary-commits.md`).

## History

Append-only. Each row = one completed stage. Cite the short SHA of the stage boundary commit so `git show <sha>` reproduces the artifact set.

| # | Stage | Done date | Commit | Notes |
|---|---|---|---|---|
| 1 | Lead | YYYY-MM-DD | — | <how the project started> |
| 2 | Intake brief | YYYY-MM-DD | <sha> | <one-line> |

## Pending

| # | Stage | Status | Gate to clear | Owner |
|---|---|---|---|---|
| 3.A | Discovery interview | pending | 5 personas × 3 modes covered | — |
| 3.B | Gap analysis | pending | As-Is / To-Be / Gap / Plan of Action filled | — |
| 4 | Proposal & SOW | pending | scope + deadlines + done-when (self-SOW for personal projects) | — |
| 5 | Spec + Design intake | pending | spec-intake.md approved (human gate) | — |
| 6 | Visual & Behavioral Modeling | pending | prototype freeze + RPM + status flows | — |
| 7 | Story slicing | pending | every REQ scenarised + tokens cited | — |
| 8 | Build | pending | every commit cites a token | — |
| 9 | Code review | pending | score ≥ 7, no dimension = 0 | — |
| 10 | QA + scenarios | pending | every REQ → TC row in TEST_MATRIX | — |
| 11 | UAT + signoff | pending | every REQ passed or excluded | — |
| 12 | Release + client update | pending | smoke checklist pass + release note | — |
| 13 | Handover + maintenance | pending | credentials access-verified + KT logged | — |

## Lane Notes

- Self-review (default): all 13 stages required. No "skip" rows allowed.
- Tiny / Normal / High-risk: opt-out only — record the opt-out reason in the row's Notes column when a stage is skipped.

## Decision Log Pointers

- Lane choice + rationale → `docs/decisions/0013-self-review-lane-and-stage-tracker.md`
- Stage boundary commit rule → `docs/decisions/0012-stage-boundary-commits.md`
- Per-stage gate definitions → `docs/WORKFLOW.md` § Stage-By-Stage Map
