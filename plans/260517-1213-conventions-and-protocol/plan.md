# Plan A — Conventions + Protocol

**Date:** 2026-05-17 · **Branch:** main · **Status:** completed 2026-05-17

**Plan status:** completed 2026-05-17. Shipped via commit `661df0f` (traceability tokens + 3 portable playbooks). Lifecycle annotations followed in `4914570`.

## Goal

Land the four lowest-risk follow-ups from decision `0004-adopt-claudekit-custom-patterns.md`:
traceability tokens, patch extension protocol, bilingual pattern playbook, composition pattern
playbook. Plus the README localization footnote (closed sub-decision Q2).

No installer changes. No new operating-model rules. Only additions to `docs/HARNESS.md`,
`docs/playbooks/`, and a 2-line `README.md` footnote.

## Source Context

- `docs/decisions/0004-adopt-claudekit-custom-patterns.md` — the umbrella decision.
- `plans/reports/xia-260517-1130-claudekit-custom-skill-scan.md` — full analysis source.
- `plans/reports/decisions-260517-1145-claudekit-custom-port-answers.md` — answer-by-answer rationale.

## Phases

| # | Phase | Output | Effort | Status |
|---|-------|--------|--------|--------|
| 1 | [Traceability tokens](phase-01-traceability-tokens.md) | New § in `docs/HARNESS.md` + `docs/TEST_MATRIX.md` row note | 30m | completed |
| 2 | [Patch extension protocol](phase-02-patch-extension-protocol.md) | New `docs/playbooks/PATCH-EXTENSION-PROTOCOL.md` + index entry | 1-2h | completed |
| 3 | [Bilingual pattern playbook](phase-03-bilingual-pattern-playbook.md) | New `docs/playbooks/bilingual-delivery-template-pattern.md` + README footnote | 35m | completed |
| 4 | [Composition pattern playbook](phase-04-composition-pattern-playbook.md) | New `docs/playbooks/playbook-composition-pattern.md` | 1h | completed |

**Plan status:** completed 2026-05-17. All grep validation checks passed.

**Total effort:** ~3-5h.

## Dependencies

- Decision `0004` must be Accepted (it is, as of 2026-05-17).
- No code changes; no test run required (docs-only).
- Phases can run in any order. Phase 2 (patch protocol) is referenced by Plan B, so completing it
  unblocks future installer work.

## Risk

Tiny. All changes are docs additions. No file deletions, no behavior changes, no installer touch.
Rollback: `git revert` each phase commit individually.

## Success Criteria

- `docs/HARNESS.md` contains a new § Traceability Tokens with composite ID format documented.
- `docs/playbooks/` contains 3 new playbook files (patch protocol, bilingual pattern, composition pattern).
- `docs/playbooks/README.md` index updated with the 3 new entries under correct groups.
- `README.md` § Harness Sources gains a 2-line localization footnote in the playbooks bullet.
- All 4 phases marked completed; `TaskList` clean.

## Out Of Scope

- Production-readiness playbook (belongs to Plan B).
- Hypercare playbook (Plan B).
- High-risk story template line for prod-readiness (Plan B).
- Installer marker-preservation behavior (Plan B).
- Pre-building any aggregator playbooks (Q5 answer: PATTERN only, no pre-built aggregators).
- Pre-translating any locale variant (Q4 answer: PATTERN only).

## Validation Note

Harness v0 has no validation scripts. Validation for this plan is **human reading review** of each new doc
plus a grep check that:

1. `docs/HARNESS.md` contains the string "Traceability Tokens".
2. `docs/playbooks/README.md` contains links to all 3 new playbook files.
3. `README.md` mentions "localizing" or "bilingual" in the playbooks bullet.
