# Phase 01 — Traceability Tokens

## Context Links

- Parent plan: `plan.md`
- Decision: `docs/decisions/0004-adopt-claudekit-custom-patterns.md` § Decision item 1 + closed sub-decision "ID co-existence".
- Source pattern: ck:rri (REQ-NNN), ck:scenario (SC-NNN), ck:e2e-flow (SC-C-NN-MM).

## Overview

- **Priority:** First — establishes vocabulary used by other phases (patch markers reference token IDs; composition pattern references freshness IDs).
- **Status:** pending.
- **Brief:** Add a § Traceability Tokens to `docs/HARNESS.md` defining REQ / SC / TC / composite-ID
  convention. Update `docs/TEST_MATRIX.md` to cite tokens.

## Key Insights

- Composite ID `US-014.REQ-001` keeps requirement scope local to the story while staying globally
  greppable. Avoids cross-story counter management.
- Existing IDs unchanged: `US-NNN` (story), `E0X-name` (epic), `NNNN` (decision, 4-digit no prefix).
  Reject `STR-` / `DEC-` prefixes — redundant.
- Tiered application: required for normal + high-risk lanes, optional for tiny lane.
  Mirrors `FEATURE_INTAKE.md` tier model.

## Requirements

Functional:
- `docs/HARNESS.md` gains § Traceability Tokens with: prefix table, composite-ID format,
  per-lane requirement, TEST_MATRIX citation rule.
- `docs/TEST_MATRIX.md` row format updated to include a "Token" column or inline citation rule.
- No changes to existing story files (`US-014` etc.) — backwards compatible.

Non-functional:
- Section under 60 lines (HARNESS.md stays scannable).
- No new automation, no schema validation. Convention only.

## Architecture

```text
docs/HARNESS.md
  └─ new § Traceability Tokens
      ├─ prefix table (REQ / SC / TC + existing US / E0X / decision)
      ├─ composite-ID rule (US-014.REQ-001 format)
      ├─ per-lane requirement (tiny optional, normal/high-risk required)
      └─ TEST_MATRIX citation rule (each row cites the token it proves)

docs/TEST_MATRIX.md
  └─ row format updated to reference tokens
```

## Related Code Files

To modify:
- `docs/HARNESS.md` — add new section after § Source Hierarchy (before § Spec Lifecycle).
- `docs/TEST_MATRIX.md` — update row schema + an example row.

To read for context:
- `docs/FEATURE_INTAKE.md` (tier model reference).
- `docs/stories/` (existing US-NNN format reference).

To create:
- None.

To delete:
- None.

## Implementation Steps

1. Read current `docs/HARNESS.md` to identify insertion point (after § Source Hierarchy).
2. Draft § Traceability Tokens with the four pieces (prefix table, composite-ID, per-lane, matrix rule).
3. Insert section; verify it does not duplicate any existing convention.
4. Open `docs/TEST_MATRIX.md`; add a "Token" column to the example row schema. If file currently has
   no rows, add a stub example like `US-014.REQ-001 | manager updates role | unit + integration | pass`.
5. Grep verify: `docs/HARNESS.md` contains "Traceability Tokens"; `docs/TEST_MATRIX.md` contains
   `US-014.REQ-` (the example).
6. Commit: `docs(harness): add traceability token convention`.

## Section Draft (paste into docs/HARNESS.md)

```markdown
## Traceability Tokens

The harness uses prefixed IDs so that requirements, scenarios, tests, and stories
can be cross-referenced by `grep` across `docs/`. Token format follows three rules:

1. **Top-level IDs keep their existing form.** Stories use `US-NNN`
   (e.g. `US-014`), epics use `E0X-kebab-name` (e.g. `E02-access-control`),
   decisions use `NNNN` 4-digit without prefix (e.g. `0004`). Do not rename them.
2. **Sub-story IDs use composite form** `US-NNN.PREFIX-MMM` where PREFIX is one of:

   | Prefix | Means | Lives in |
   | --- | --- | --- |
   | REQ | A discrete requirement inside a story | story packet |
   | SC | A scenario / edge case to prove | scenario notes or test plan |
   | TC | A test case (manual or automated) | TEST_MATRIX row, test file name |

   Example: `US-014.REQ-001`, `US-014.SC-003`, `US-014.TC-007`.
3. **TEST_MATRIX rows cite the token they prove.** Any row in
   `docs/TEST_MATRIX.md` must reference at least one composite token in its
   description column.

Per-lane application:

| Lane | Token use |
| --- | --- |
| Tiny | Optional. Inline narrative is fine. |
| Normal | Required for any new requirement or scenario the story introduces. |
| High-risk | Required. Every entry in `execplan.md`, `design.md`, `validation.md` must reference its tokens. |

Reject `STR-` and `DEC-` prefixes — `US-` and 4-digit decision numbering already
cover those concepts.
```

## Todo List

- [ ] Read current `docs/HARNESS.md` and pick insertion point.
- [ ] Draft + insert § Traceability Tokens.
- [ ] Update `docs/TEST_MATRIX.md` row schema and add stub example.
- [ ] Grep verify both files.
- [ ] Commit with conventional message.

## Success Criteria

- `grep -l "Traceability Tokens" docs/HARNESS.md` returns the file.
- `grep "US-014.REQ-" docs/TEST_MATRIX.md` returns at least one row.
- `docs/HARNESS.md` total length unchanged in spirit (section added, no other deletes).

## Risk Assessment

Tiny. Docs-only addition. No agent behavior change until a story actually uses tokens.

## Security Considerations

None. Convention only.

## Next Steps

- Phase 02 (patch extension protocol) can reference the token system in examples.
- Plan B (production-readiness playbook) will require REQ/TC tokens on the checklist rows.
