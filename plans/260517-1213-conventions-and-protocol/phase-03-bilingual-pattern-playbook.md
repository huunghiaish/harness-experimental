# Phase 03 — Bilingual Pattern Playbook + README Footnote

## Context Links

- Parent plan: `plan.md`
- Decision: `docs/decisions/0004-adopt-claudekit-custom-patterns.md` § Decision item 4
  + closed sub-decision "README localization mention".
- Source pattern: ClaudeKit Custom UAT/signoff/client-update — title in VN, automation/IDs in EN.

## Overview

- **Priority:** Third — independent of Phase 01 and 02.
- **Status:** pending.
- **Brief:** Document the bilingual delivery template pattern (title localized, automation/IDs in English)
  as a portable playbook. Add a 2-line discoverability footnote to `README.md`. Do NOT pre-translate
  any template.

## Key Insights

- Pattern is locale-agnostic: works for VN/EN, JP/EN, KR/EN, ES/EN.
- Split rule: human-readable parts (titles, descriptions, client-facing copy) localize; machine-readable
  parts (IDs, tokens, automation strings, code fences, file paths) stay English.
- Decision 0004 Q4 chose "ship pattern only" — no `templates/locale-vi/` shipped. Locale variants emerge
  as forks when real demand surfaces.
- README footnote is the discoverability layer — without it, users find the playbook only by browsing
  `docs/playbooks/` index.

## Requirements

Functional:
- New file `docs/playbooks/bilingual-delivery-template-pattern.md` documenting the fork pattern.
- `docs/playbooks/README.md` index entry under "Workflow recipe" or "Structural framework" group
  (recommend Structural — it's about how files are organized).
- `README.md` § Harness Sources — playbooks bullet gains a 2-line localization footnote.

Non-functional:
- Playbook under 90 lines.
- One concrete VN example block (most likely audience). Document JP example as a `<details>` block
  to avoid bloating the main flow.

## Architecture

```text
docs/playbooks/
├── bilingual-delivery-template-pattern.md   ← NEW
│   ├─ when to fork (signal: need locale-specific titles for client deliverables)
│   ├─ split rule (localize vs keep EN)
│   ├─ fork directory pattern (templates/locale-vi/ next to templates/)
│   ├─ concrete example (1 VN template fragment)
│   └─ anti-patterns
└── README.md (updated)
    └─ new row under "Structural framework"

README.md
└─ § Harness Sources → playbooks bullet (updated)
    └─ 2-line footnote pointing to localization + composition patterns
```

## Related Code Files

To modify:
- `docs/playbooks/README.md` — add 1 row.
- `README.md` — extend the existing `docs/playbooks/` bullet in § Harness Sources by 2 lines.

To read for context:
- `docs/playbooks/template.md` (playbook shape).
- `~/Projects/claudekit-custom/skills/ck-uat/` (live bilingual example, 5 min skim).

To create:
- `docs/playbooks/bilingual-delivery-template-pattern.md`.

## Implementation Steps

1. Skim 1 ck:uat or ck:signoff file to confirm the localize/keep-EN split (5 min).
2. Draft `bilingual-delivery-template-pattern.md` from skeleton below.
3. Update `docs/playbooks/README.md` — add row in "Structural framework" group.
4. Open `README.md`, locate § Harness Sources, find the `docs/playbooks/` bullet (currently 2 lines).
   Append 2 lines pointing to the localization and composition playbooks. Diff target below.
5. Grep verify: `grep -i "bilingual" README.md` returns a line; `grep -l "locale-vi" docs/playbooks/`
   returns the new playbook.
6. Commit: `docs(playbooks): add bilingual delivery template pattern`.

## Playbook Draft Skeleton (paste into docs/playbooks/bilingual-delivery-template-pattern.md)

```markdown
# Bilingual Delivery Template Pattern

How to fork harness templates into a locale variant (e.g. Vietnamese, Japanese)
without losing portability of the automation, IDs, and cross-team references.

## When To Fork

Use this pattern when:
- Client-facing deliverables (UAT, signoff, handover) must be in a locale.
- Internal automation, IDs, tokens, file paths should stay English so that
  cross-region teams can still read and grep them.

## Split Rule

| Stays English | Localizes |
| --- | --- |
| File paths, folder names | Document titles |
| IDs and tokens (`US-014`, `REQ-001`) | Section headers visible to client |
| Code fences, commands, env var names | Body prose addressed to client |
| Comments inside code blocks | Table column labels visible to client |
| Internal links (`docs/...`) | Public-facing labels in those links |

Rule of thumb: if a grep-er across regions needs to find it, keep it English.
If a client reads it, localize it.

## Fork Directory Pattern

Place locale variants next to defaults:

```text
docs/templates/
├── story.md                       # default (English)
├── high-risk-story/...            # default
├── locale-vi/
│   ├── story.md                   # Vietnamese titles + body
│   └── high-risk-story/...
└── locale-ja/                     # only if/when needed
    └── ...
```

The default `templates/*` is the source-of-truth. Locale variants are
allowed to lag the default during a transition — note staleness in a header
comment.

## Concrete Example — Vietnamese UAT Snippet

```markdown
<!-- locale-vi/uat.md fragment -->

# Biên bản kiểm thử nghiệm thu UAT — US-014

| Mã kịch bản | Mô tả | Kết quả mong đợi | Ghi chú |
| --- | --- | --- | --- |
| US-014.TC-001 | Quản lý cập nhật vai trò thành viên | Vai trò mới được lưu | |
```

The story ID (`US-014`), test ID (`US-014.TC-001`), and column type stay
English. The titles, descriptions, and document name localize.

## Anti-Patterns

- Translating IDs (`HS-014` instead of `US-014`). Breaks grep + traceability.
- Forking the whole harness into a locale repo. Use the `locale-*` subdir
  instead — keeps default in sync.
- Mixing locales inside one file. One file = one locale.
- Translating playbook content. Playbooks are agent-facing and stay English.
```

## README Footnote Diff Target

Current `README.md` § Harness Sources bullet (after Phase 3 work):

```markdown
- `docs/playbooks/`: reusable recipes for recurring tooling, environment, and
  workflow problems. Read before fighting a familiar symptom.
  Includes patterns for localizing templates (bilingual delivery) and composing
  multi-step playbooks.
```

(The last 2 lines are the addition. Existing 2 lines unchanged.)

## Todo List

- [ ] Skim ck:uat file for split confirmation.
- [ ] Draft `docs/playbooks/bilingual-delivery-template-pattern.md`.
- [ ] Update `docs/playbooks/README.md` index.
- [ ] Append 2 lines to `README.md` playbooks bullet.
- [ ] Grep verify.
- [ ] Commit.

## Success Criteria

- `docs/playbooks/bilingual-delivery-template-pattern.md` exists.
- `README.md` mentions "bilingual" or "localizing" in the playbooks section.
- `docs/playbooks/README.md` lists the new file.

## Risk Assessment

Tiny. Docs only. No file moves, no template forks.

## Security Considerations

None.

## Next Steps

- When the first regional fork happens, that team should run the pattern and report friction. Update
  the playbook with `Variant` sections as needed (per playbooks/README.md variant convention).
