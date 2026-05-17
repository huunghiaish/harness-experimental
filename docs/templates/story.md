# US-XXX Story Title

## Status

planned

## Lane

tiny | normal | high-risk

## Product Contract

Describe the behavior this story must make true.

## Relevant Product Docs

- `docs/product/...`

## Acceptance Criteria

- Criterion 1.
- Criterion 2.
- Criterion 3.

## Design Notes

- Commands:
- Queries:
- API:
- Tables:
- Domain rules:
- UI surfaces:

## Implementation Guardrails

Hold true during the build step regardless of the agent or human implementing this story.

- Stay inside scope. Only change behavior this story names. Out-of-scope cleanup → new story or backlog row.
- Do not change architecture without a new `docs/decisions/NNNN-*.md`. Renaming the stack, swapping the ORM, restructuring folders, etc. count.
- Do not delete code that is referenced elsewhere unless the deletion is the point of the story. If unused, prove it (grep) and cite the proof.
- For any UI surface, handle loading, empty, and error states — not just the happy path.
- For any form or API input, add input validation at the boundary.
- Explain what changed in the commit body. Cite at least one `US-NNN.REQ-MMM` or `US-NNN.SC-MMM` token.

## Validation

| Layer | Expected proof |
| --- | --- |
| Unit | |
| Integration | |
| E2E | |
| Platform | |
| Release | |

## Harness Delta

Document any harness updates made or proposed because of this story.

## Evidence

Add commands, reports, screenshots, or links after validation exists.
