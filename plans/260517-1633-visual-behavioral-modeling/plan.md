# Plan — Visual & Behavioral Modeling Stage (Stage 6)

Date: 2026-05-17 · Status: completed · Lane: harness-improvement (normal)

## Why

Same-day follow-up to commit 22c0529 (decision 0007). User surfaced a structural gap from real client-work pain: between stage 5 (Spec + Design intake) and stage 6 (Story slicing in 0007's flow), there was no explicit phase for producing visual + behavioral artifacts that anchor non-tech client review, AI code-generation handoff, and UAT pass criteria.

Triple-use rule: one frozen prototype + behavioral diagrams serve client review + AI code generation + UAT visual gate.

## Scope

Insert new stage 6 between current 5 and 6 in the meta-playbook. Renumber 6-12 → 7-13. Ship playbook + 2 templates (each with VN fork) + decision + index updates + heredoc sync.

## Out Of Scope

- Pre-translating internal playbook (agent-facing, stays English).
- Separate playbooks per sub-step (KISS — one workflow recipe covers all 3 sub-steps).
- Hard-coding Claude Design as the only tool (violates Independence Principle; ship tool ladder instead).
- Retroactive edits to decision 0007 (clean audit — new decision 0008 references 0007 as prior).
- Templates for User Flow / Business Workflow / ERD draft / Sitemap (inline guidance in playbook is enough; promote to templates only on demand-evidence trigger).

## Files Shipped

### New playbook

- `docs/playbooks/visual-and-behavioral-modeling.md`

### New templates (EN + VN forks)

- `docs/templates/role-permission-matrix.md` + `docs/templates/locale-vi/role-permission-matrix.md`
- `docs/templates/status-flow.md` + `docs/templates/locale-vi/status-flow.md`

### Edits to existing files

- `docs/playbooks/solo-dev-client-delivery.md` — insert stage 6, renumber 6-12 → 7-13, update flow ASCII, Decision Matrix table (new column), conflict-with-harness section (new rule), Related section
- `docs/playbooks/README.md` — add visual-and-behavioral-modeling row + update meta-playbook description (13 stages now)
- `docs/templates/README.md` — new "Visual & behavioral modeling templates" group
- `docs/HARNESS_BACKLOG.md` — accepted entry citing decision 0008
- `scripts/install-harness.sh` — heredoc gains 5 new files (1 playbook + 2 EN templates + 2 VN templates + 1 decision)

### Decision

- `docs/decisions/0008-visual-behavioral-modeling-stage.md`

## Phases

Single linear session — no parallel phases. Tracked via TaskList 8 tasks (#14-21).

| Task | Output |
| --- | --- |
| 14 | role-permission-matrix.md (EN + VN) |
| 15 | status-flow.md (EN + VN) |
| 16 | visual-and-behavioral-modeling.md |
| 17 | solo-dev-client-delivery.md edits (stage insertion + renumber) |
| 18 | playbooks/README + templates/README updates |
| 19 | decision 0008 |
| 20 | HARNESS_BACKLOG entry + install heredoc sync |
| 21 | This plan note + commit |

## Risk Assessment

- **Renumbering risk** — stages 6-12 became 7-13. Mitigated by: meta-playbook only shipped 7 hours earlier in commit 22c0529; no production project linked to numbered stages yet.
- **Tool availability risk** — Claude Design (https://claude.ai/design) is user-cited as Anthropic's product. May have limited availability. Mitigated by: tool ladder with 6 ranks; non-blocking substitution.
- **Quality risk** — playbook + templates not yet exercised on real project. First VN e-commerce project run is the verification gate. Lifecycle marker `experimental` reflects this.
- **Template growth risk** — Sitemap / User Flow / Business Workflow / ERD draft promoted to templates later if demand evidence appears. Currently inline guidance only.

## Validation

Validation happens on the first real project run, same as decision 0007 (visualization stage runs as part of the same VN e-commerce flow). Promotion gates:

- Playbook → `verified` after 1 project completes stage 6 without unwritten workarounds.
- Each new template → eligible for Variant amendment if friction appears.

## Audit Trail

- Prior decision (commercial wrapper): `docs/decisions/0007-solo-dev-client-delivery-templates.md` (commit 22c0529).
- This decision: `docs/decisions/0008-visual-behavioral-modeling-stage.md`.
- Backlog entry: `docs/HARNESS_BACKLOG.md` (search "Visual & behavioral modeling stage").

## Next Steps

1. Commit + push (same flow as commit 22c0529).
2. Install harness into VN e-commerce project repo, run through stages 1-5 (already covered).
3. Run stage 6 (this stage) using Claude Design — capture friction in `docs/visuals/prototype/README.md`.
4. After project run, append Variant sections per playbook lifecycle rules.
5. Re-evaluate Decision Matrix table after 2-3 different project types have run stage 6.
