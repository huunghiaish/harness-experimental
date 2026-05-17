# Phase 01 — Discovery Interview Playbook

> **Independence note:** This phase executes fully without `claudekit-custom`
> installed. The Skim steps below are optional enrichment; the draft
> skeleton in the body contains everything required for execution.

## Context Links

- Parent plan: `plan.md`
- Decision: `docs/decisions/0005-roadmap-execution-direction.md`
  (Plan C ordering).
- Source pattern: ck:rri — 5-persona interview generating REQ-IDs + decisions.
- Harness anchor: `docs/HARNESS.md` § Traceability Tokens (REQ tokens this
  playbook emits).
- Related harness file: `docs/FEATURE_INTAKE.md` (the playbook output feeds
  spec intake; reference how outputs map to intake input types).

## Overview

- **Priority:** First in Plan C — feeds the rest of the loop.
- **Status:** pending.
- **Brief:** Ship a portable discovery interview playbook (5-persona,
  3-question-mode framework) that produces a REQ-token list and decisions
  log. Drop-in for spec intake's "first buildout" path; reusable for change
  requests too.

## Key Insights

- ck:rri runs 40-60 questions per session across 5 personas. Harness needs
  the FRAMEWORK (personas + question shapes), not a fixed question count —
  scope flexes with intake type.
- Output tokens are `REQ-MMM` scoped to whatever story will adopt them.
  Composite form `US-NNN.REQ-MMM` happens when the requirement lands in a
  specific story.
- 3 question modes (challenge / guided / explore) cover different discovery
  needs: challenge = stress-test assumptions, guided = walk through known
  decision points, explore = uncover unknowns.
- Playbook must be `discovery-input`-folder-agnostic. Harness does not
  mandate the ck:custom `00-brief/...08-change-input/` folder structure
  (per backlog item B1).

## Requirements

Functional:
- New playbook `docs/playbooks/discovery-interview-playbook.md` covering:
  persona list (5 personas with role + concerns), question modes (3 modes
  with purpose + when-to-use), question bank by persona × mode (3-5
  starter questions each), output shape (REQ list + decisions log + open
  questions list).
- Register in `docs/playbooks/README.md` under "Workflow recipe" group
  (it is a sequenced multi-step procedure).
- Reference from `docs/FEATURE_INTAKE.md` § "New spec" input type as the
  canonical first step of Phase 1 spec intake. ONE LINE only — do not
  bloat intake doc.

Non-functional:
- Playbook under 180 lines.
- All personas named generically (End User, BA, QA, Developer, Operator) —
  no project-specific titles.
- Question bank examples are generic; no fintech/healthcare/SME-specific
  examples in main playbook. Optional appendix block with one fully-worked
  example is allowed.

## Architecture

```text
docs/playbooks/
├── discovery-interview-playbook.md      ← NEW
│   ├─ When to run (spec intake first pass; change request; brownfield
│   │   discovery)
│   ├─ Personas (5 with role + primary concerns)
│   ├─ Question modes (3 with purpose + signal each one captures)
│   ├─ Question bank (persona × mode matrix; 3-5 starters each)
│   ├─ Output shape (REQ list, decisions log, open questions list)
│   ├─ Stop condition (when to wrap the interview)
│   └─ Hand-off (where outputs land; how to start spec intake from them)
└── README.md (updated — index entry under Workflow recipe group)

docs/FEATURE_INTAKE.md
└─ § Spec Approval Gate "Phase 1" bullet — add one-line reference to playbook
```

## Related Code Files

To modify:
- `docs/playbooks/README.md` — add row in "Workflow recipe" group.
- `docs/FEATURE_INTAKE.md` — add one-line reference under § Spec Approval Gate.

To read for context:
- `~/Projects/claudekit-custom/skills/ck-rri/SKILL.md` (5-min skim — persona +
  question-mode idiom).
- `docs/playbooks/template.md` (playbook shape).
- `docs/FEATURE_INTAKE.md` (insertion point).

To create:
- `docs/playbooks/discovery-interview-playbook.md`.

## Implementation Steps

1. **Optional enrichment** (skip if `claudekit-custom` not installed):
   skim `~/Projects/claudekit-custom/skills/ck-rri/SKILL.md` (~5 min) to
   absorb persona + question-mode framing. The skeleton below already
   contains everything required.
2. Draft persona list with concise role + primary concerns (1-2 lines each).
3. Draft question modes with purpose + when-to-use.
4. Build question bank: 5×3 matrix. 3-5 starter questions per cell. Keep
   wording generic, action-oriented.
5. Define output shape: 3 buckets (REQ list with one-line description per
   item; decisions log entries linking to candidate decision doc; open
   questions list).
6. Define stop condition: "stop when 2 consecutive challenge-mode questions
   produce no new info, OR all 5 personas have at least one REQ + decision."
7. Define hand-off: REQ list feeds story candidate identification; decisions
   log feeds initial decision doc drafts; open questions list joins
   `docs/HARNESS_BACKLOG.md` if cross-project.
8. Register in `docs/playbooks/README.md` (Workflow recipe group, second row).
9. Add one-line reference in `docs/FEATURE_INTAKE.md` § Spec Approval Gate
   Phase 1 bullet (something like: "Use `docs/playbooks/discovery-interview-playbook.md`
   as the canonical interview shape if you need structure.").
10. Grep verify: `grep -l "discovery-interview-playbook" docs/playbooks/README.md`
    and `docs/FEATURE_INTAKE.md` both return.
11. Commit: `docs(playbooks): add discovery interview playbook (Plan C-01)`.

## Playbook Draft Outline (paste into docs/playbooks/discovery-interview-playbook.md)

```markdown
# Discovery Interview Playbook

Portable interview shape for turning a new spec, change request, or
brownfield mystery into a REQ list + decisions log + open questions list.

## When To Run

- Spec intake Phase 1 (first buildout from `SPEC.md`).
- Change request analysis where the request is ambiguous.
- Brownfield onboarding where the code says one thing and the request
  implies another.

Skip when:
- The request is a tiny-lane patch with clear acceptance.
- The decision is already documented and the work is just executing it.

## Personas

| Persona | Role | Primary concerns |
| --- | --- | --- |
| End User | Person who interacts with the final surface | Usability, frequency, failure recovery, language |
| BA | Bridge between stakeholder intent and spec | Scope clarity, decision traceability, conflict resolution |
| QA | Owner of proof | Acceptance criteria, edge cases, regression surface |
| Developer | Owner of build | Feasibility, integration surface, tech debt risk |
| Operator | Owner of run | Deploy shape, monitoring, rollback, support load |

## Question Modes

| Mode | Purpose | Use when |
| --- | --- | --- |
| Challenge | Stress-test assumptions in the prompt | Spec sounds tidy — check it holds under pressure |
| Guided | Walk through known decision points | Intake type is familiar; just need to fill the form |
| Explore | Uncover unknown unknowns | Brownfield or vague prompts; find what the prompt didn't say |

## Question Bank (Persona × Mode)

For each cell, 3-5 starter questions. Below is the matrix shape; fill at
playbook authoring time.

### End User × Challenge
- What happens when the network drops mid-action?
- Who else might hit this surface that you haven't mentioned?
- ...

### End User × Guided
- What is the most common path through this screen?
- ...

(Repeat for all 5×3 = 15 cells.)

## Output Shape

After the session, produce three artifacts:

1. **REQ list** — markdown table.
   | ID | Description (one line) | Source persona | Confidence |
   | --- | --- | --- | --- |
   | REQ-001 | ... | End User | high |

   Composite form `US-NNN.REQ-001` happens when the REQ lands in a story.

2. **Decisions log** — markdown list. Each entry: decision name + 1-line
   summary + link to draft decision file path (even if file doesn't exist
   yet).

3. **Open questions list** — markdown list. Questions the session could not
   resolve. These either enter the next intake pass or `docs/HARNESS_BACKLOG.md`
   if they are cross-project.

## Stop Condition

End the session when EITHER:
- 2 consecutive challenge-mode questions produce no new information.
- All 5 personas have at least 1 REQ and 1 decisions log entry.
- Time-box hits (recommended 60-90 min for spec intake).

## Hand-Off

- REQ list → input to story candidate identification in `docs/stories/epics/`.
- Decisions log → seed for `docs/decisions/NNNN-*.md` files.
- Open questions list → next iteration, or backlog.

## Variant Section

(Append per harness `docs/playbooks/README.md` § Use Order — when this
playbook fails or partially works, append a Variant section here. Do not
delete the original shape.)
```

## Todo List

- [ ] (Optional) Skim ck:rri SKILL.md if `claudekit-custom` installed.
- [ ] Draft full playbook from skeleton.
- [ ] Register in `docs/playbooks/README.md`.
- [ ] Add one-line reference in `docs/FEATURE_INTAKE.md`.
- [ ] Grep verify both files.
- [ ] Commit with conventional message.

## Success Criteria

- File exists under 180 lines.
- All 5 personas + 3 modes documented.
- Output shape names REQ list explicitly with composite token example.
- `docs/FEATURE_INTAKE.md` reference is exactly one line; no other change.

## Risk Assessment

Tiny. Docs-only. No agent behaviour change until first project actually runs
the interview.

## Security Considerations

None.

## Next Steps

- Phase 02 (scenario taxonomy) consumes the REQ list as input — its scenarios
  cite which REQs they cover.
- Phase 03 (delivery closure story) references the REQ list and the scenarios
  during sign-off.
