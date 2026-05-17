# Plan C — Discovery + Delivery Loop

**Date:** 2026-05-17 · **Branch:** main · **Status:** Ready for execution

## Goal

Close the harness's discovery → story → proof → delivery loop by adding three
portable artifacts: a discovery interview playbook, a scenario taxonomy
playbook, and a delivery closure story template. All cite Plan A's traceability
tokens; none assume a locale, comms channel, or stack.

## Source Context

- `docs/decisions/0004-adopt-claudekit-custom-patterns.md` — defers these
  three items to "a separate decision when prioritized".
- `docs/decisions/0005-roadmap-execution-direction.md` — promotes Plan C to
  execute next (before Plan B).
- `plans/reports/xia-260517-1130-claudekit-custom-skill-scan.md` — Tier S
  items S1, S2, S3 source analysis.
- `plans/reports/roadmap-260517-1234-claudekit-custom-port-roadmap.md` —
  Plan C scope.

## Phases

| # | Phase | Output | Effort | Status |
|---|-------|--------|--------|--------|
| 1 | [Discovery interview playbook](phase-01-discovery-interview-playbook.md) | `docs/playbooks/discovery-interview-playbook.md` | 2-3h | pending |
| 2 | [Scenario taxonomy playbook](phase-02-scenario-taxonomy-playbook.md) | `docs/playbooks/scenario-taxonomy-playbook.md` | 1-2h | pending |
| 3 | [Delivery closure story template](phase-03-delivery-closure-story-template.md) | `docs/templates/delivery-closure-story/` + 3 templates | 3-4h | pending |

**Total effort:** ~6-9h.

## Dependencies

- Plan A complete (uses REQ / SC / TC token convention from `docs/HARNESS.md` § Traceability Tokens).
- Decision 0005 accepted (this plan exists because of it).
- Independent of Plan B (installer concerns do not affect docs additions).

## Risk

Tiny. Docs + templates only. No installer touch, no code, no operating-model
file change. Rollback per phase: `git revert` the phase commit.

## Success Criteria

- `docs/playbooks/discovery-interview-playbook.md` exists, registered in
  `docs/playbooks/README.md` under appropriate group.
- `docs/playbooks/scenario-taxonomy-playbook.md` exists, registered.
- `docs/templates/delivery-closure-story/` exists with 3 templates (UAT,
  signoff, client-update). Cited from a new story shape note in
  `docs/templates/README.md` or equivalent index if one exists.
- Every shipped artifact references composite tokens (`US-NNN.REQ-MMM`, etc.)
  consistent with Plan A conventions.
- No locale-specific content (titles in English; bilingual fork is the
  user's responsibility via `docs/playbooks/bilingual-delivery-template-pattern.md`).
- No comms-channel lock-in (client-update template names the channel as
  a placeholder, not Telegram-specific).

## Out Of Scope

- Pre-translated Vietnamese variants of any template (decision 0004 Q4).
- Telegram-specific automation (decision 0004 — channel-neutral pattern only).
- Building an aggregator playbook that wraps discovery → scenario → delivery
  (decision 0004 Q5 — wait for friction).
- XRE-style formal SRS extraction (rejected outright per roadmap).
- ck:rri persona inventory beyond the 5 documented (no scope creep).
- Code changes (no app source exists in harness v0).

## Validation Note

Validation is human reading review plus grep checks:

1. `grep -l "discovery-interview-playbook" docs/playbooks/README.md` returns the index.
2. `grep -l "scenario-taxonomy-playbook" docs/playbooks/README.md` returns the index.
3. `ls docs/templates/delivery-closure-story/` lists 3 templates.
4. `grep -r "US-NNN.REQ-" docs/templates/delivery-closure-story/` returns at least
   one citation example per template.
5. No file in this plan contains the strings "Telegram", "Vietnamese", or
   "VN" outside of explicit "example only" annotations.

## Decisions Needed Before Start

None — decision 0005 already accepted. Phase 03's "story shape vs playbook"
question was resolved in roadmap report: story shape (mirrors
`docs/templates/high-risk-story/`).
