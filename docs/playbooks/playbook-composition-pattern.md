# Playbook Composition Pattern

How to wrap several playbooks into a single meta-playbook when the same
sequence keeps recurring — and how to recognise when atomic playbooks are
clearer than composition.

## When To Compose

Compose into a meta-playbook when ALL three hold:

1. The same 3+ playbooks run in the same order in 2+ projects.
2. The output of one step is the input of the next.
3. Users have shown friction remembering the order (repeated questions,
   skipped steps, mistakes).

If any one is false, keep playbooks atomic. Premature composition hides
the decision points and makes failure recovery harder.

## When To Keep Atomic

Keep playbooks atomic when:

- Any combination of the steps might run independently.
- Sub-playbooks have separate failure modes that the user must triage.
- The "compose" instinct is coming from "this looks tidy" not from
  measured recurring friction.

## Hand-Off Contract

Every step in a meta-playbook must declare:

| Field | Purpose |
| --- | --- |
| Input | What artifact (file path, token, decision id) the step needs to start. |
| Output | What artifact the step produces, named so the next step can grep it. |
| Skip-when | Condition that lets the user skip this step (e.g. "skip if output is < 7 days old and inputs unchanged"). |

Without these three fields, the meta-playbook is just a checklist — and a
checklist hides which step actually depends on which.

## Idempotency + Freshness Metadata

For expensive composed steps, emit a sidecar metadata file:

```json
// docs/<artifact-folder>/.meta.json
{
  "generated_at": "2026-05-17T12:30:00Z",
  "generated_by": "<playbook-name>",
  "inputs_hash": "<sha256 of input artifacts>",
  "version": 1
}
```

Skip-rerun rule:

- If `.meta.json` age < the playbook-declared TTL (typical: 7 days) AND
  `inputs_hash` unchanged, skip the rerun and reuse the existing output.
- The user can force a rerun with a `--regenerate` flag or by deleting the
  `.meta.json` file.

This pattern is borrowed from ClaudeKit Custom's `ck:design-system`
(`check_freshness.py`) — it prevents wasteful re-runs when nothing relevant
changed upstream.

## Example A — Should Compose

Three playbooks always run in this order on every greenfield project:
discovery interview → scope baseline → tech design. Each takes the previous
output as input. Users keep asking "what is the next step?" — clear signal
to wrap.

Meta-playbook: `greenfield-bootstrap-flow.md` (would live here once
friction has been measured). Each step block:

```text
### Step 1 — Discovery interview
Input:      SPEC.md
Output:     plans/<date>-<slug>/rri-report.md
Skip-when:  rri-report.md exists, was updated in last 7 days, SPEC.md unchanged
Playbook:   discovery-interview-playbook.md (Plan B will deliver)
```

## Example B — Should NOT Compose

`headless-browser-blank-screenshot.md` and
`e2e-recording-user-guide-quality.md` are both tooling fixes. They may or
may not co-occur. They share no output flow.

Keep them atomic. If a user trips on both in the same week, that is two
separate playbook hits, not a composition signal.

## Anti-Patterns

- **Building an aggregator "because it would be tidy"** without measured
  friction. Wait for the third "what is next?" question before wrapping.
- **Skipping the hand-off contract.** Without input / output / skip-when,
  the meta-playbook hides which steps actually depend on which.
- **Hard-coding the sub-playbook order without a skip-when.** Forces
  re-running expensive steps unnecessarily on every invocation.
- **One giant aggregator that wraps every playbook.** Splits the harness
  into "the aggregator and the rest" — the opposite of portability.

## Next Steps

- Do NOT pre-build any meta-playbook in this phase. The pattern is shipped;
  aggregators emerge from real friction.
- When the third project asks the same composition question, build the
  first aggregator using this pattern. Reference it back from this file
  as a worked example.
