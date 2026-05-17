# Plan — Solo-Dev Client Delivery Commercial Wrapper

Date: 2026-05-17 · Status: completed · Lane: harness-improvement (normal)

## Why

Real solo-dev VN e-commerce / dashboard project starting same week needs commercial wrapper around the existing harness. Gap identified in `plans/reports/xia-260517-1538-solo-dev-vibecode-vs-harness.md` compare audit. Demand evidence + adoption rationale in `docs/decisions/0007-solo-dev-client-delivery-templates.md`.

## Scope

Five new commercial templates + one meta-playbook + `locale-vi/` starter + story template addendum + index updates + decision + backlog entry. Single-session ship.

## Out of Scope

- Pre-translating internal templates (story, decision, spec-intake, high-risk-story, validation-report) — agent-facing, stay English.
- Building PRD-lite / UX-text-spec / Tech-spec-lite single-doc templates — equivalent already exists across product docs + story + ARCHITECTURE + decisions.
- Story packet for the actual client project — that lives in the project repo after harness install.
- AI-coding-per-task prompt template — guardrails added inline to story.md instead.

## Files Shipped

### English defaults (new)

- `docs/templates/client-intake-brief.md`
- `docs/templates/proposal-sow.md`
- `docs/templates/change-request-log.md`
- `docs/templates/release-note.md`
- `docs/templates/maintenance-proposal.md`

### Vietnamese locale forks (new)

- `docs/templates/locale-vi/client-intake-brief.md`
- `docs/templates/locale-vi/proposal-sow.md`
- `docs/templates/locale-vi/change-request-log.md`
- `docs/templates/locale-vi/release-note.md`
- `docs/templates/locale-vi/maintenance-proposal.md`
- `docs/templates/locale-vi/delivery-closure-story/01-uat-plan.md`
- `docs/templates/locale-vi/delivery-closure-story/02-signoff.md`
- `docs/templates/locale-vi/delivery-closure-story/03-client-update.md`
- `docs/templates/locale-vi/project-closure-story/01-handover-docs.md`

### Meta-playbook (new)

- `docs/playbooks/solo-dev-client-delivery.md`

### Edits to existing files

- `docs/templates/story.md` — added § Implementation Guardrails.
- `docs/templates/README.md` — created (was missing).
- `docs/playbooks/README.md` — added meta-playbook row to workflow recipe group.
- `docs/playbooks/bilingual-delivery-template-pattern.md` — added § Current Locale Forks In This Harness.
- `docs/HARNESS_BACKLOG.md` — added accepted entry citing this plan + decision 0007.

### Decision

- `docs/decisions/0007-solo-dev-client-delivery-templates.md`

## Phases

Single linear session — no parallel phases. Tracked via TaskList 13 tasks (#1-13).

| Task | Output |
| --- | --- |
| 1 | `proposal-sow.md` |
| 2 | `maintenance-proposal.md` |
| 3 | `release-note.md` |
| 4 | `change-request-log.md` |
| 5 | `client-intake-brief.md` |
| 6 | 5 × `locale-vi/` forks (new templates) |
| 7 | 4 × `locale-vi/` forks (existing closure templates) |
| 8 | `solo-dev-client-delivery.md` meta-playbook |
| 9 | `story.md` § Implementation Guardrails |
| 10 | `playbooks/README.md` + `templates/README.md` + bilingual playbook update |
| 11 | `decisions/0007-*.md` |
| 12 | `HARNESS_BACKLOG.md` accepted entry |
| 13 | This plan note |

## Risk Assessment

- **Adoption risk** — templates shipped before 2-project demand threshold. Mitigated by decision § Tradeoffs.
- **Locale risk** — VN starter biases harness. Mitigated by client-facing surface only (9 files), not full inventory.
- **Quality risk** — templates not yet exercised on a real project. The actual VN project run is the first verification; expect Variant amendments per playbook lifecycle rules. Lifecycle marker `experimental` on the meta-playbook reflects this.

## Validation

Validation happens on the first real project run. Promotion gates:

- Meta-playbook → `verified` after 1 project completes without unwritten workarounds.
- Each new template → eligible for amendment via Variant section if friction appears.
- Bilingual pattern → review after 1 full VN delivery cycle.

## Audit Trail

- Source compare report: `plans/reports/xia-260517-1538-solo-dev-vibecode-vs-harness.md`.
- Decision: `docs/decisions/0007-solo-dev-client-delivery-templates.md`.
- Backlog entry: `docs/HARNESS_BACKLOG.md` (search "Commercial wrapper for solo-dev client delivery").

## Next Steps

1. Solo dev installs harness into the new VN project repo (`scripts/install-harness.sh`).
2. Solo dev runs `docs/playbooks/solo-dev-client-delivery.md` stage 2 onward (intake brief → discovery → SOW).
3. After project ships M4, run `docs/playbooks/session-retrospective.md` at project scope (not per-session). Feed friction back as Variant sections on the affected playbooks/templates.
4. After project closure, re-evaluate the meta-playbook for `experimental` → `verified` promotion.
