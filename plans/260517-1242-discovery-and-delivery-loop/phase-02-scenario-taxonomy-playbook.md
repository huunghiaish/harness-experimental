# Phase 02 — Scenario Taxonomy Playbook

> **Independence note:** This phase executes fully without `claudekit-custom`
> installed. The Skim steps below are optional enrichment; the draft
> skeleton in the body contains everything required for execution.

## Context Links

- Parent plan: `plan.md`
- Decision: `docs/decisions/0005-roadmap-execution-direction.md`.
- Source pattern: ck:scenario — 12-dimension edge-case taxonomy.
- Harness anchors:
  - `docs/HARNESS.md` § Traceability Tokens (SC tokens this playbook emits).
  - `docs/TEST_MATRIX.md` (rows cite SC tokens this playbook produces).

## Overview

- **Priority:** Second in Plan C — consumes REQ list from Phase 01.
- **Status:** pending.
- **Brief:** Ship a portable scenario taxonomy playbook covering 12 edge-case
  dimensions, producing an SC-token list per requirement / per story. Each
  scenario becomes a `TEST_MATRIX` row candidate.

## Key Insights

- 12 dimensions cover the universe of edge cases that recur across
  domains: input validation, concurrency, state, boundary, error,
  performance, security, compliance, integration, data, deployment,
  rollback. Skipping dimensions is allowed when the requirement
  obviously doesn't touch them (e.g. a docs-only feature skips
  compliance, security, deployment).
- Output SC tokens are `SC-MMM` scoped to whatever story will adopt them.
  Composite form `US-NNN.SC-MMM` happens at story-attach time.
- Scenario taxonomy runs per-REQ or per-story phase, not per-project.
  Phase scope reduces noise.
- Per harness intake tiers: required for normal + high-risk, optional for
  tiny (matches token convention from Plan A).

## Requirements

Functional:
- New playbook `docs/playbooks/scenario-taxonomy-playbook.md` covering:
  the 12 dimensions (name, definition, sample questions, when to skip),
  output table shape (SC ID, dimension, scenario summary, expected
  outcome, REQ-traceback), per-tier application rule, hand-off to
  `docs/TEST_MATRIX.md`.
- Register in `docs/playbooks/README.md` under "Workflow recipe" group
  (sequenced after discovery interview).
- Reference from `docs/HARNESS.md` § Traceability Tokens (one sentence
  pointing to this playbook as the canonical SC generator).

Non-functional:
- Playbook under 160 lines.
- All 12 dimensions named generically. No domain examples in the main
  table — keep an optional appendix block for one fully-worked example
  (e.g. "user updates own profile" generating ~5 SC entries across 4
  dimensions).
- No tool prescription (do not require Playwright, Jest, etc. — proof
  shape is the team's choice).

## Architecture

```text
docs/playbooks/
├── scenario-taxonomy-playbook.md      ← NEW
│   ├─ When to run (per story phase, normal/high-risk lanes)
│   ├─ The 12 dimensions (definition + sample questions per)
│   ├─ Output table shape (SC ID, dimension, summary, expected, REQ-traceback)
│   ├─ Skip rule (which dimensions to omit when irrelevant)
│   ├─ Per-tier application (intake tier → required/optional)
│   └─ Hand-off (each SC becomes a TEST_MATRIX row candidate)
└── README.md (updated)

docs/HARNESS.md
└─ § Traceability Tokens — add one sentence pointing to this playbook as canonical SC source
```

## Related Code Files

To modify:
- `docs/playbooks/README.md` — add row.
- `docs/HARNESS.md` — append one sentence to § Traceability Tokens table
  caption or below the table.

To read for context:
- `~/Projects/claudekit-custom/skills/ck-scenario/SKILL.md` (5 min skim for
  dimension framing).
- `docs/HARNESS.md` § Traceability Tokens (insertion point).

To create:
- `docs/playbooks/scenario-taxonomy-playbook.md`.

## Implementation Steps

1. **Optional enrichment** (skip if `claudekit-custom` not installed):
   skim `~/Projects/claudekit-custom/skills/ck-scenario/SKILL.md` (~5 min)
   to confirm dimension naming. The skeleton below already names all 12.
2. Draft 12-dimension table: name + 1-line definition + 2-3 sample
   questions each.
3. Draft output table shape with explicit SC token column (`SC-001`,
   composite at story-attach time).
4. Define skip rule: "skip a dimension if the requirement does not
   plausibly touch it; declare skipped dimensions explicitly in the
   scenario doc header so reviewers see the omission was intentional."
5. Define per-tier application: required for normal + high-risk, optional
   for tiny — match Plan A's token tier rule.
6. Define hand-off: each SC becomes a TEST_MATRIX row when proof effort
   begins.
7. Register in `docs/playbooks/README.md`.
8. Append sentence to `docs/HARNESS.md` § Traceability Tokens pointing to
   this playbook as the canonical SC generator.
9. Grep verify: `grep -l "scenario-taxonomy-playbook" docs/HARNESS.md
   docs/playbooks/README.md` returns both.
10. Commit: `docs(playbooks): add scenario taxonomy playbook (Plan C-02)`.

## Playbook Draft Outline (paste into docs/playbooks/scenario-taxonomy-playbook.md)

```markdown
# Scenario Taxonomy Playbook

Twelve-dimension shape for turning a requirement into an explicit list of
edge cases to prove. Output feeds `docs/TEST_MATRIX.md`.

## When To Run

- Per story phase (not per project) in normal + high-risk lanes.
- After the story's REQ list is stable.
- Re-run when REQ list changes substantially.

Skip when the lane is tiny — inline narrative coverage is sufficient.

## The Twelve Dimensions

| Dimension | Definition | Sample questions |
| --- | --- | --- |
| Input validation | What if the input is malformed, empty, oversized, or wrong type? | What happens on a 10MB upload? What happens on Unicode in a field expecting ASCII? |
| Concurrency | What if two actors hit the same surface at the same time? | What if two managers update the same role simultaneously? What is the lock granularity? |
| State | What if the entity is in an unexpected state when the action runs? | What if the user is suspended? What if the resource was deleted between fetch and update? |
| Boundary | What if values are at zero, max, or just past either? | What if the page is page 0? What if 100,001 items exist when the cap is 100k? |
| Error | What if a dependency fails? | What if the email service is down? What is the recovery path? |
| Performance | What if the load is 100x expected? | What is the slow case? What backpressure exists? |
| Security | What if the actor is malicious? | What if a non-admin guesses the admin URL? What if input is SQL/XSS payload? |
| Compliance | What rules govern this surface? | Does GDPR / SOC2 / domain regulation apply? Where is consent captured? |
| Integration | What if a downstream API changes shape? | What schema validation runs on the boundary? What is the contract test? |
| Data | What if the data is dirty (nulls, duplicates, drift)? | What happens with an orphan FK? What about a stale soft-delete? |
| Deployment | What can break at deploy time? | What is the migration order? What about blue/green compatibility? |
| Rollback | What if we have to revert? | Is the migration reversible? Is the feature gated by a flag that can flip back? |

Each dimension may be skipped — declare skipped dimensions in the scenario
doc header so reviewers see intentional omission.

## Output Shape

```markdown
# Scenarios — US-014 (manager updates member role)

Skipped dimensions: compliance (no regulatory surface for this story).

| SC ID | Dimension | Scenario summary | Expected outcome | REQ-traceback |
| --- | --- | --- | --- | --- |
| US-014.SC-001 | Input validation | Empty role string | Reject with 400; no DB write | US-014.REQ-001 |
| US-014.SC-002 | Concurrency | Two managers update same member's role within 100ms | Last write wins; both managers see toast acknowledging current state | US-014.REQ-003 |
| US-014.SC-003 | Security | Non-manager calls API directly | Reject with 403; audit log entry | US-014.REQ-002 |
| ... | | | | |
```

## Per-Tier Application

| Lane | Application |
| --- | --- |
| Tiny | Optional. Inline narrative coverage is sufficient. |
| Normal | Required. Cover the dimensions that plausibly apply; declare skips. |
| High-risk | Required. Cover all 12 dimensions explicitly — skip-declarations included. |

## Hand-Off

Each SC entry becomes a TEST_MATRIX row when proof effort begins. The
Contract column cites the composite token (`US-014.SC-001`); the proof
columns (Unit / Integration / E2E / Platform) capture which level proves it.

## Variant Section

(Append a Variant block here if this taxonomy fails to capture an edge case
that recurs. Do not delete the original 12 dimensions.)
```

## Todo List

- [ ] (Optional) Skim ck:scenario SKILL.md if `claudekit-custom` installed.
- [ ] Draft playbook from skeleton.
- [ ] Register in `docs/playbooks/README.md`.
- [ ] Append sentence to `docs/HARNESS.md` § Traceability Tokens.
- [ ] Grep verify.
- [ ] Commit.

## Success Criteria

- File exists under 160 lines.
- All 12 dimensions present with definition + sample questions.
- Output table example uses composite token form (`US-014.SC-001`).
- Per-tier rule matches Plan A's token tier rule.

## Risk Assessment

Tiny. Docs only.

## Security Considerations

None.

## Next Steps

- Phase 03 delivery closure references SC tokens during UAT planning.
- Plan D code-review-scoring playbook may cite this playbook for coverage
  rubric.
