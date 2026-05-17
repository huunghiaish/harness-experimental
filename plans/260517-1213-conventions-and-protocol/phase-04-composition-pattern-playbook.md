# Phase 04 — Playbook Composition Pattern

## Context Links

- Parent plan: `plan.md`
- Decision: `docs/decisions/0004-adopt-claudekit-custom-patterns.md` § Decision item 5.
- Source pattern: ClaudeKit Custom aggregators (`ck:ux-design` wraps `ck:persona` + `ck:brand-guidelines`
  + `ck:design-system` + …), plus `check_freshness.py` idempotency + `--regenerate` flag idiom.

## Overview

- **Priority:** Fourth — independent of other phases.
- **Status:** pending.
- **Brief:** Document the playbook composition pattern (when to compose, hand-off contract,
  idempotency check, `--regenerate` convention). Do NOT pre-build any aggregator playbooks; aggregators
  emerge from real friction.

## Key Insights

- Composition is for situations where 3+ playbooks always run in the same order and users keep
  forgetting which one is next. Below that bar, atomic playbooks are clearer.
- Hand-off contract: each step in a composed playbook must declare input, output, and skip-when.
  Without the contract, "composition" is just a checklist.
- Idempotency check: a meta-playbook with expensive steps should check freshness of the previous
  output before re-running. Pattern from ck:design-system uses `<artifact>.meta.json` with `generated_at`
  field; skip rerun if age < N days unless `--regenerate` passed.
- Decision 0004 explicitly says: ship the pattern, NOT any aggregator. Resist the temptation to
  pre-build `full-discovery-playbook.md` or similar.

## Requirements

Functional:
- New file `docs/playbooks/playbook-composition-pattern.md` documenting composition rules.
- `docs/playbooks/README.md` index entry under "Structural framework" group.
- No new aggregator playbooks shipped.

Non-functional:
- Under 100 lines.
- Two compact examples: one "should compose" (discovery → scope → tech-design), one "should NOT compose"
  (atomic playbook).

## Architecture

```text
docs/playbooks/
├── playbook-composition-pattern.md      ← NEW
│   ├─ when to compose vs keep atomic
│   ├─ hand-off contract (input/output/skip-when per step)
│   ├─ idempotency check pattern (.meta.json + age check + --regenerate)
│   ├─ example A (compose-friendly scenario)
│   ├─ example B (atomic-preferred scenario)
│   └─ anti-patterns
└── README.md (updated)
    └─ new row under "Structural framework"
```

## Related Code Files

To modify:
- `docs/playbooks/README.md` — add 1 row.

To read for context:
- `~/Projects/claudekit-custom/skills/ck-ux-design/SKILL.md` (5 min skim to confirm aggregator shape).
- `~/Projects/claudekit-custom/skills/ck-design-system/` (look for `check_freshness.py` or equivalent).
- `docs/playbooks/template.md` (playbook shape).

To create:
- `docs/playbooks/playbook-composition-pattern.md`.

## Implementation Steps

1. Skim 1 ck aggregator SKILL.md to confirm composition idiom (5 min).
2. Find freshness check pattern in ck-design-system (5 min).
3. Draft `playbook-composition-pattern.md` from skeleton below.
4. Update `docs/playbooks/README.md` index.
5. Grep verify: `grep -l "composition" docs/playbooks/playbook-composition-pattern.md` returns file.
6. Commit: `docs(playbooks): add playbook composition pattern`.

## Playbook Draft Skeleton (paste into docs/playbooks/playbook-composition-pattern.md)

```markdown
# Playbook Composition Pattern

How to wrap several playbooks into a single meta-playbook when the same
sequence keeps recurring — and how to recognise when atomic playbooks are
clearer than composition.

## When To Compose

Compose into a meta-playbook when ALL three hold:

1. The same 3+ playbooks run in the same order in 2+ projects.
2. The output of one step is the input of the next.
3. Users have shown friction remembering the order (questions, mistakes,
   skipped steps).

If any one is false, keep playbooks atomic. Premature composition hides
the decision points and makes failure recovery harder.

## When To Keep Atomic

Keep playbooks atomic when:
- Any combination of the steps might run independently.
- Sub-playbooks have separate failure modes that the user must triage.
- The "compose" instinct is coming from "this looks tidy" not from real
  recurring friction.

## Hand-Off Contract

Every step in a meta-playbook must declare:

| Field | Purpose |
| --- | --- |
| Input | What artifact (file path, token, decision id) the step needs to start. |
| Output | What artifact the step produces, named so the next step can grep it. |
| Skip-when | Condition that lets the user skip this step (e.g. "skip if output is < 7 days old"). |

Without these three fields, the meta-playbook is just a checklist.

## Idempotency + Freshness Metadata

For expensive composed steps, emit a sidecar metadata file:

```text
docs/<artifact-folder>/.meta.json
{
  "generated_at": "2026-05-17T12:30:00Z",
  "generated_by": "<playbook-name>",
  "inputs_hash": "<sha256 of input artifacts>",
  "version": 1
}
```

Skip rerun rule:
- If `.meta.json` age < the playbook-declared TTL (typical: 7 days) AND inputs
  unchanged, skip rerun and reuse output.
- The user can force rerun with a `--regenerate` flag or by deleting the
  `.meta.json` file.

This pattern is borrowed from ClaudeKit Custom's `ck:design-system`
(`check_freshness.py`) — it prevents wasteful re-runs when nothing relevant
changed upstream.

## Example A — Should Compose

Three playbooks always run in this order on every greenfield project:
discovery interview → scope baseline → tech design. Each takes the previous
output as input. Users keep asking "what is the next step?" — clear signal
to wrap.

Meta-playbook: `greenfield-bootstrap-flow.md` (would live in
`docs/playbooks/` once friction has been measured). Each step block:

```text
### Step 1 — Discovery interview
Input:      `SPEC.md`
Output:     `plans/<date>-<slug>/rri-report.md`
Skip-when:  rri-report.md exists and was updated in last 7 days
Playbook:   discovery-interview-playbook.md
```

## Example B — Should NOT Compose

`headless-browser-blank-screenshot.md` and `e2e-recording-user-guide-quality.md`
are both tooling fixes. They may or may not co-occur. No shared output flow.
Keep atomic. If a user trips on both in the same week, that is two separate
playbook hits, not a composition signal.

## Anti-Patterns

- Building an aggregator "because it would be tidy" without measured friction.
- Skipping the hand-off contract. Without it, the meta-playbook hides which
  steps actually depend on which.
- Hard-coding the sub-playbook order without a skip-when. Forces re-running
  expensive steps unnecessarily.
- One giant aggregator that wraps every playbook. Splits the harness into
  "the aggregator and the rest" — opposite of portability.
```

## Todo List

- [ ] Skim ck:ux-design SKILL.md.
- [ ] Find freshness check pattern source in ck-design-system.
- [ ] Draft `docs/playbooks/playbook-composition-pattern.md`.
- [ ] Update `docs/playbooks/README.md` index.
- [ ] Grep verify.
- [ ] Commit.

## Success Criteria

- `docs/playbooks/playbook-composition-pattern.md` exists, under ~100 lines.
- File has explicit "when to compose" + "when NOT to compose" guidance.
- File covers hand-off contract + idempotency metadata pattern.
- `docs/playbooks/README.md` lists the new file under "Structural framework".
- No new aggregator playbooks created in this phase.

## Risk Assessment

Tiny. Docs only.

## Security Considerations

None.

## Next Steps

- When real friction surfaces (3+ projects asking the same composition question), build the first
  aggregator playbook using this pattern. Do NOT build it speculatively.
- Plan B may indirectly use the idempotency pattern for prod-readiness checklist execution.
