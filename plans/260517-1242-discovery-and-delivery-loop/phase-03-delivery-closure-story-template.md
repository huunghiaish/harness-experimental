# Phase 03 — Delivery Closure Story Template

> **Independence note:** This phase executes fully without `claudekit-custom`
> installed. The Skim steps below are optional enrichment; the draft
> skeleton in the body contains everything required for execution.

## Context Links

- Parent plan: `plan.md`
- Decision: `docs/decisions/0005-roadmap-execution-direction.md`.
- Sibling templates: `docs/templates/high-risk-story/` (4 files —
  `overview.md`, `design.md`, `execplan.md`, `validation.md`).
- Source pattern: ck:uat + ck:signoff + ck:client-update chain (without VN
  locale, without Telegram lock-in).
- Harness anchors:
  - `docs/HARNESS.md` § Traceability Tokens.
  - `docs/playbooks/bilingual-delivery-template-pattern.md` (locale fork).
  - `docs/FEATURE_INTAKE.md` (new story shape registered here).

## Overview

- **Priority:** Third in Plan C — synthesises REQ + SC tokens from Phases
  01–02 into a closure shape.
- **Status:** pending.
- **Brief:** Ship `docs/templates/delivery-closure-story/` — a new story
  shape (mirroring `high-risk-story/`) holding three templates: UAT plan,
  signoff document, client-update message. All locale-agnostic. All
  comms-channel-agnostic.

## Key Insights

- Closure is a story TYPE, not a one-off doc. A release ships a story; that
  story needs a closure artifact set. Treating it as a story SHAPE (folder
  with multiple templates) mirrors how `high-risk-story/` is organised and
  makes the shape discoverable.
- 3 templates cover the close-out workflow:
  - `01-uat-plan.md` — journey-based test plan citing SC tokens.
  - `02-signoff.md` — acceptance doc linking REQ tokens to evidence.
  - `03-client-update.md` — comms scaffold; placeholder channel
    (Slack/email/Telegram/whatever the org runs).
- A 4th file `overview.md` mirrors `high-risk-story/overview.md` — names
  the closure, links to the story being closed, captures pass/fail
  outcome.
- All templates designed for English default. Locale forks happen per
  `bilingual-delivery-template-pattern.md` — that playbook references
  this shape as the canonical default.
- `FEATURE_INTAKE.md` must register this shape alongside high-risk so
  intake knows to reach for it.

## Requirements

Functional:
- New directory `docs/templates/delivery-closure-story/` with 4 files:
  - `overview.md` (closure header)
  - `01-uat-plan.md` (journey-based UAT)
  - `02-signoff.md` (acceptance doc)
  - `03-client-update.md` (comms scaffold)
- Register the new shape in `docs/FEATURE_INTAKE.md` as a closure-class
  story shape (one-line bullet under § Output or new § Story Shapes if
  cleaner).
- Cross-reference from `docs/playbooks/bilingual-delivery-template-pattern.md`
  (already mentions UAT — confirm or add reference to this template).

Non-functional:
- Each template under 80 lines.
- All tokens in examples are placeholder (`US-NNN.REQ-MMM`).
- No locale-specific words ("Biên bản", "Telegram", etc.) in default
  templates. Examples may show `<channel>` placeholder.
- Mirror `high-risk-story/` filename convention: numbered prefix for
  ordered files, no prefix for overview.

## Architecture

```text
docs/templates/
├── high-risk-story/                    (existing)
│   ├── overview.md
│   ├── design.md
│   ├── execplan.md
│   └── validation.md
└── delivery-closure-story/             ← NEW
    ├── overview.md
    ├── 01-uat-plan.md
    ├── 02-signoff.md
    └── 03-client-update.md

docs/FEATURE_INTAKE.md
└─ § Output or new § Story Shapes — register delivery-closure-story alongside
   high-risk-story shape

docs/playbooks/bilingual-delivery-template-pattern.md
└─ Confirm cross-reference to delivery-closure-story templates (already
   referenced as "UAT/Signoff/Client-Update"; tighten to point at the
   specific template paths)
```

## Related Code Files

To modify:
- `docs/FEATURE_INTAKE.md` — register the new story shape.
- `docs/playbooks/bilingual-delivery-template-pattern.md` — tighten cross-ref.

To read for context:
- `docs/templates/high-risk-story/*.md` (shape parity reference).
- `~/Projects/claudekit-custom/skills/ck-uat/SKILL.md`,
  `ck-signoff/SKILL.md`, `ck-client-update/SKILL.md` (5 min total skim).

To create:
- `docs/templates/delivery-closure-story/overview.md`
- `docs/templates/delivery-closure-story/01-uat-plan.md`
- `docs/templates/delivery-closure-story/02-signoff.md`
- `docs/templates/delivery-closure-story/03-client-update.md`

## Implementation Steps

1. Read `docs/templates/high-risk-story/*.md` (~5 min) to absorb shape +
   tone parity.
2. **Optional enrichment** (skip if `claudekit-custom` not installed):
   skim `~/Projects/claudekit-custom/skills/ck-uat/`, `ck-signoff/`,
   `ck-client-update/` SKILL.md headers (~5 min each). The skeletons below
   already cover the closure shape.
3. Create the directory and 4 files using skeletons below.
4. Register in `docs/FEATURE_INTAKE.md`. Pick the smallest insertion —
   recommend adding a § Story Shapes section if none exists, or appending
   a line in § Output describing both `high-risk-story/` and
   `delivery-closure-story/` shapes.
5. Tighten cross-reference in `docs/playbooks/bilingual-delivery-template-pattern.md`
   — replace generic "UAT/Signoff" mention with explicit path.
6. Grep verify:
   - `ls docs/templates/delivery-closure-story/ | wc -l` returns 4.
   - `grep -l "delivery-closure-story" docs/FEATURE_INTAKE.md` returns.
   - `grep -r "US-NNN.REQ-" docs/templates/delivery-closure-story/` returns
     at least one match per template (proving token convention is shown).
7. Commit: `docs(templates): add delivery-closure-story shape (Plan C-03)`.

## File Skeletons

### docs/templates/delivery-closure-story/overview.md

```markdown
# Delivery Closure — <story id, e.g. US-014>

## Story

Link: `docs/stories/epics/<EXX>-name/<US-NNN>-name.md`

## Release / Iteration

<release tag, sprint id, or date>

## Outcome

passed | partial | failed

## Summary

One paragraph describing what shipped, what worked, what did not.

## Required Artifacts

- [ ] `01-uat-plan.md` complete (every covered SC token marked passed/failed)
- [ ] `02-signoff.md` signed (named approver per side)
- [ ] `03-client-update.md` sent (channel + timestamp recorded)

## Open Follow-Ups

Bullet list. Each open item links to a story candidate, backlog entry, or
decision doc.
```

### docs/templates/delivery-closure-story/01-uat-plan.md

```markdown
# UAT Plan — <story id>

## Scope

REQ tokens covered: US-NNN.REQ-001, US-NNN.REQ-002, ...
SC tokens covered: US-NNN.SC-001, ...

## Journey

Step-by-step user journey through the surface being accepted. Numbered.

1. Actor logs in as <role>.
2. Actor navigates to <screen>.
3. Actor performs <action>.
4. ...

## Test Cases

| TC ID | Path | Steps | Expected | Result |
| --- | --- | --- | --- | --- |
| US-NNN.TC-001 | Happy | ... | ... | pass |
| US-NNN.TC-002 | Edge — empty input | ... | ... | pass |

Each test cites its SC token in the Path column when applicable. Failures
must link to a follow-up entry in `overview.md` § Open Follow-Ups.

## Cap

Recommended ≤ 40 test cases per UAT pass. If more is needed, split into
multiple UAT passes (e.g. one per epic phase) rather than letting the
table balloon.
```

### docs/templates/delivery-closure-story/02-signoff.md

```markdown
# Signoff — <story id>

## Approver — Client Side

Name: <name>
Role: <role>
Date: YYYY-MM-DD
Signature mechanism: <email approval / e-signature / written reply>

## Approver — Delivery Side

Name: <name>
Role: <role>
Date: YYYY-MM-DD

## REQ Coverage

| REQ ID | One-line description | Evidence link |
| --- | --- | --- |
| US-NNN.REQ-001 | ... | `01-uat-plan.md#US-NNN.TC-001` |

Every REQ must have at least one evidence link. Open evidence gaps block
signoff.

## Exclusions

REQ tokens explicitly OUT of this signoff (e.g. deferred to next release).
Each exclusion cites the decision doc that defers it.

## Conditions

Any conditional acceptance ("signed pending fix of X by date Y"). Empty
section if signoff is unconditional.
```

### docs/templates/delivery-closure-story/03-client-update.md

```markdown
# Client Update — <story id>

## Channel

<Slack / email / Telegram / whatever the org runs>

## Recipients

<distribution list or channel name>

## Subject

<one-line subject>

## Body

<two-to-five sentence summary of what shipped, what to look for in the
release, and the next-action ask if any>

Examples of next-action asks:
- "Please confirm UAT acceptance by <date>."
- "No action required — release notes attached."
- "Bug found in <area>; rollback planned for <date>; update to follow."

## Sent

Date: YYYY-MM-DD
Time: HH:MM (timezone)
Sent by: <name or automation source>
```

## Todo List

- [ ] Read `high-risk-story/*.md` for shape parity.
- [ ] (Optional) Skim ck:uat / signoff / client-update SKILL.md headers if `claudekit-custom` installed.
- [ ] Create directory + 4 files using skeletons.
- [ ] Register shape in `docs/FEATURE_INTAKE.md`.
- [ ] Tighten cross-ref in bilingual playbook.
- [ ] Grep verify.
- [ ] Commit.

## Success Criteria

- 4 files exist in `docs/templates/delivery-closure-story/`.
- All 4 contain at least one composite token placeholder example.
- `FEATURE_INTAKE.md` mentions both `high-risk-story/` and
  `delivery-closure-story/` as story shapes.
- No locale-specific strings in templates.
- Bilingual playbook cross-reference updated.

## Risk Assessment

Tiny. Docs + templates only.

## Security Considerations

`03-client-update.md` body must not contain credentials, tokens, or
PII. Add a one-line "no secrets, no PII" warning in the template header.

## Next Steps

- Plan D `project-closure-story/` template will mirror this shape for
  end-of-project (vs end-of-release) handoff.
- After 3 projects use this shape, evaluate whether to fold journey
  guidance into a separate UAT-design playbook.
