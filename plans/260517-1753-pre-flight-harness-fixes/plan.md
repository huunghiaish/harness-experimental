# Pre-Flight Harness Fixes

**Date:** 2026-05-17
**Trigger:** real paid client project starting (VN, high-risk, web/AI/payment/multi-role/DB ~30 entities, greenfield).
**Source:** `plans/reports/review-260517-1728-pre-flight-workflow-audit.md`.

## Goal

Fix critical + recommended harness gaps before first real-project run starts.

## Decisions Applied

- **Q1 (SPEC.md location):** raw inputs live in `docs/discovery/` per decision 0009; no special `SPEC.md` at root. README + WORKFLOW + FEATURE_INTAKE updated to reflect.
- **Q2 (7 global docs):** mapping section in HARNESS.md + ship 2 stubs (`code-standards.md`, `deployment-guide.md`).
- **Q3 (lane):** high-risk web/AI app, 30 entities, full 13 stages will fire.
- **Q4 (locale):** VN — locale-vi templates fire; bilingual pattern gets verification.
- **Greenfield:** stage 3.B gap-analysis skips (no As-Is).
- **Status-flow rule:** strict — every stateful entity must have a status-flow file.

## Phases

| Phase | Scope | Effort | File |
|---|---|---|---|
| 1 | Foundation fixes (F1-F8): discovery clarification, doc mapping, 2 stubs, stack-decision template, installer bootstrap | ~3h | `phase-01-foundation-fixes.md` |
| 2 | Stack-specific gaps (S1-S4): build playbook, AI playbook, payment playbook, status-flow rule clarification | ~2h | `phase-02-stack-specific-gaps.md` |
| 3 | Quality of life (Q1-Q4): QUICKSTART, story example move, backlog cleanup, perf-budget + PII stubs | ~1h | `phase-03-quality-of-life.md` |

## Status

| Phase | Status |
|---|---|
| 1 | completed (commits 1-4) |
| 2 | completed (commit 5) |
| 3 | completed (commit 6) |

## Commit Strategy

6 commits total:
1. F1+F2 — discovery-as-spec-source clarification (README + WORKFLOW + FEATURE_INTAKE)
2. F3+F4+F5 — project doc mapping + code-standards + deployment-guide stubs
3. F6 — stack-selection decision template
4. F7+F8 — installer bootstrap mode + heredoc sync
5. S1+S2+S3+S4 — build + AI + payment playbooks + status-flow rule
6. Q1+Q2+Q3+Q4 — QUICKSTART + example move + backlog cleanup + perf-budget/PII stubs

## Decisions To Create

- `0011-bootstrap-installer-mode.md` — implements HARNESS_BACKLOG bootstrap-flag item.
- (No new decision needed for F1/F2/F3 — clarification of existing decision 0009 and reconciliation with global rules.)

## Success Criteria

- README greenfield path puts client/brainstorm input under `docs/discovery/`, not `./SPEC.md`.
- HARNESS.md contains § Project Doc Mapping resolving global-CLAUDE.md doc expectations.
- `docs/templates/code-standards.md` + `docs/templates/deployment-guide.md` ship as stubs.
- `docs/templates/decisions/stack-selection.md` template exists with 8-10 stack questions.
- Installer `--bootstrap` flag works: git init + copy + optional `--spec <path>` → places file in `docs/discovery/`.
- 3 new playbooks ship: `build-execution.md`, `ai-feature-integration.md`, `payment-integration.md`.
- `visual-and-behavioral-modeling.md` § C.6 clarifies strict status-flow rule.
- `docs/QUICKSTART.md` exists (30 lines).
- `docs/stories/US-001-install-harness.md` moved to `docs/stories/examples/`.
- HARNESS_BACKLOG: B2 + B3 rejected; bootstrap-flag accepted; B1 + B6 status unchanged.
- `high-risk-story/design.md` has performance-budget table; `spec-intake.md` has PII inventory section.
- Installer heredoc updated with all new files (drift check passes).
