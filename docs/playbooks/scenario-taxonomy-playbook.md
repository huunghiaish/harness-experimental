# Scenario Taxonomy Playbook

**Lifecycle:** experimental · **First use:** TBD · **Verified by:** none

> Twelve-dimension shape for turning a requirement into an explicit list
> of edge cases to prove. Output feeds `docs/TEST_MATRIX.md`.

## When To Run

- Per story phase (not per project) in normal + high-risk lanes.
- After the story's REQ list is stable.
- Re-run when the REQ list changes substantially.

Skip when the lane is tiny — inline narrative coverage is sufficient.

## The Twelve Dimensions

Each dimension may be skipped — declare skipped dimensions in the
scenario doc header so reviewers see intentional omission.

| Dimension | Definition | Sample questions |
| --- | --- | --- |
| Input validation | Malformed, empty, oversized, or wrong-type input | What happens on a 10MB upload? On Unicode in an ASCII field? On a negative count? |
| Concurrency | Two actors hit the same surface at the same time | What if two managers update the same role simultaneously? What is the lock granularity? |
| State | Entity is in an unexpected state when the action runs | What if the user is suspended? What if the resource was deleted between fetch and update? |
| Boundary | Values at zero, max, or just past either | What if the page is page 0? What if 100,001 items exist when the cap is 100k? |
| Error | A dependency fails | What if the email service is down? What is the recovery path? What does the user see? |
| Performance | Load is 100x expected | What is the slow case? What backpressure exists? What times out first? |
| Security | The actor is malicious | What if a non-admin guesses the admin URL? What if input is SQL/XSS payload? |
| Compliance | External rules govern the surface | Does GDPR / SOC2 / domain regulation apply? Where is consent captured? |
| Integration | A downstream API changes shape | What schema validation runs on the boundary? What is the contract test? |
| Data | Data is dirty (nulls, duplicates, drift) | What happens with an orphan FK? With a stale soft-delete? With a NULL where NOT NULL was expected? |
| Deployment | Something breaks at deploy time | What is the migration order? What about blue/green compatibility? |
| Rollback | We have to revert | Is the migration reversible? Is the feature gated by a flag that can flip back? |

## Output Shape

Per story (or per requirement when granularity demands), produce a
scenarios doc with this shape:

```markdown
# Scenarios — US-014 (manager updates member role)

Skipped dimensions: compliance (no regulatory surface for this story).

| SC ID | Dimension | Scenario summary | Expected outcome | REQ-traceback |
| --- | --- | --- | --- | --- |
| US-014.SC-001 | Input validation | Empty role string | Reject with 400; no DB write | US-014.REQ-001 |
| US-014.SC-002 | Concurrency | Two managers update same member's role within 100ms | Last write wins; both managers see toast acknowledging current state | US-014.REQ-003 |
| US-014.SC-003 | Security | Non-manager calls API directly | Reject with 403; audit log entry | US-014.REQ-002 |
| US-014.SC-004 | Rollback | Feature flag flips off mid-update | In-flight requests complete; new requests see old surface | US-014.REQ-001 |
```

SC IDs are local-to-story (`SC-001`, `SC-002`, ...). The composite form
`US-NNN.SC-MMM` appears anywhere the scenario is referenced outside its
story file — including `docs/TEST_MATRIX.md` rows and code-review notes.

## Per-Tier Application

Matches Plan A's token tier rule (see `docs/HARNESS.md` § Traceability
Tokens).

| Lane | Application |
| --- | --- |
| Tiny | Optional. Inline narrative coverage is sufficient. |
| Normal | Required. Cover dimensions that plausibly apply; declare skips. |
| High-risk | Required. Cover all 12 dimensions explicitly — skip-declarations included. |

## Hand-Off

Each SC entry becomes a `docs/TEST_MATRIX.md` row when proof effort
begins. The Contract column cites the composite token
(`US-014.SC-001`); the proof columns (Unit / Integration / E2E /
Platform) capture which level proves it. The TC ID assigned by the
test suite (`US-014.TC-007`) closes the loop back to the SC.

Example matrix linkage: `US-014.REQ-001` → `US-014.SC-001` →
`US-014.TC-001`.

## Variant Section

(Append a Variant block here if this taxonomy fails to capture an edge
case that recurs across projects. Do not delete the original 12
dimensions.)

## Related

- `docs/HARNESS.md` § Traceability Tokens — SC token format.
- `docs/playbooks/discovery-interview-playbook.md` — produces the REQ
  list this playbook consumes.
- `docs/TEST_MATRIX.md` — destination for each SC row.
- `docs/playbooks/README.md` § Use Order — how to add a Variant section.
