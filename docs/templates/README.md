# Templates

Reusable scaffolds for the artifacts the harness expects. Copy or stub into the project repo when the corresponding stage is reached. The default templates are English; client-facing templates have Vietnamese forks under `locale-vi/` per `docs/playbooks/bilingual-delivery-template-pattern.md`.

## Index

### Story templates — derived per work item

| File | Stage | Notes |
| --- | --- | --- |
| [story.md](story.md) | All implementation lanes | Normal-lane stories. Includes § Implementation Guardrails (scope, architecture, deletion, state handling, validation, commit hygiene). |
| [high-risk-story/](high-risk-story/) | High-risk lane only | Four-file packet: `overview`, `execplan`, `design`, `validation`. |
| [spec-intake.md](spec-intake.md) | New-spec input type | Phase 1 of `docs/FEATURE_INTAKE.md` § Spec Approval Gate. |
| [decision.md](decision.md) | Architectural / contract decisions | Numbered `docs/decisions/NNNN-*.md`. |
| [validation-report.md](validation-report.md) | After validation | Evidence + proof status for a story. |

### Closure templates — used per delivery and per project

| File | Stage | Notes |
| --- | --- | --- |
| [delivery-closure-story/](delivery-closure-story/) | Per release / UAT | `overview`, `01-uat-plan`, `02-signoff`, `03-client-update`. VN fork available. |
| [project-closure-story/](project-closure-story/) | End-of-project handover | `overview`, `01-handover-docs`, `02-credentials-handover`, `03-knowledge-transfer`. VN fork available (handover-docs only — others stay neutral). |

### Commercial templates — solo-dev paid-client delivery

Composed by `docs/playbooks/solo-dev-client-delivery.md`. All have `locale-vi/` forks.

| File | Stage | Notes |
| --- | --- | --- |
| [client-intake-brief.md](client-intake-brief.md) | Pre-discovery | Vendor-internal: should we accept this project? Red/green flags, complexity estimate, decline-reply template. |
| [proposal-sow.md](proposal-sow.md) | After discovery, before signing | Single-page SOW. Includes scope in/out, milestone-gated payment, change-request policy, acceptance conditions. |
| [change-request-log.md](change-request-log.md) | Always-on after SOW signing | Client-facing CR log. Includes classification, severity, effort tags, 5 reply templates. |
| [release-note.md](release-note.md) | Per release deploy | Includes pre-deploy + post-deploy smoke + rollback + client-update message. |
| [maintenance-proposal.md](maintenance-proposal.md) | At or after project handover | SLA tiers (Basic/Standard/Premium), severity table, scope in/out, SLA exclusions. |

## Localization

Client-facing templates fork into `locale-vi/` (Vietnamese). IDs, file paths, tokens, code fences, and env var names stay English per `docs/playbooks/bilingual-delivery-template-pattern.md`. Other locales (e.g. `locale-ja/`) emerge as forks when a real regional project requests them.

## Adding A New Template

1. Decide group (story / closure / commercial) and place under that section.
2. Keep templates **shape**, not **content** — placeholders like `<one-line>` and `YYYY-MM-DD`, no project-specific data.
3. Update this README's index in the same commit.
4. If the template is client-facing, fork to `locale-vi/` (and other relevant locales) per the bilingual pattern.
5. If the template represents a new commercial / process stage, link it from `docs/playbooks/solo-dev-client-delivery.md` § The Flow.
