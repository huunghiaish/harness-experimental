# 0007 Solo-Dev Client Delivery Templates + Vietnamese Locale Fork Starter

Date: 2026-05-17

## Status

Accepted

## Context

The harness shipped strong internal-facing artifacts (intake, story templates, scenario taxonomy, code-review scoring, closure templates, handover) but had no commercial wrapper around them: no SOW/proposal, no maintenance offer, no release-note, no client-facing change-request log, no pre-discovery client-intake brief.

A real solo-dev VN e-commerce / dashboard project (high-complexity lane) is starting in this same week (2026-05-17), running the harness end-to-end from lead to handover. The original "wait-for-friction" promotion rule (per `0005-roadmap-execution-direction.md` § 5: 2 distinct projects OR 1 project × 3+ hits) is satisfied in spirit by a 12-stage end-to-end run on one project — every stage that lacks a template will independently surface as friction. Pre-shipping the templates avoids inventing them under client deadline pressure.

Locale: the project's client requires Vietnamese deliverables. Pre-translating the harness contradicts the bilingual pattern's neutrality (`docs/playbooks/bilingual-delivery-template-pattern.md`: "The harness never assumes a specific locale list"). However, leaving the VN fork to the project install means each of 5 new templates + 4 existing closure templates must be re-translated by the solo dev under deadline. Compromise: ship a `locale-vi/` starter that covers only the client-facing surface; internal templates stay English-only.

The 5 new commercial templates were identified in `plans/reports/xia-260517-1538-solo-dev-vibecode-vs-harness.md` (a compare-mode audit against an AI-suggested 15-stage solo-dev workflow).

## Decision

Ship the following in this same commit batch:

1. **Five new English commercial templates** under `docs/templates/`:
   - `client-intake-brief.md` — vendor-internal pre-discovery one-pager (accept/decline gate).
   - `proposal-sow.md` — single-page client-facing SOW with milestone-gated payment, scope in/out, change-request policy, acceptance conditions.
   - `change-request-log.md` — append-only client-facing CR log with classification (bug/CR/new-feature/UX/clarification), severity, effort tags, 5 reply templates.
   - `release-note.md` — per-release artifact with pre-deploy checklist, post-deploy smoke, rollback plan, client-update message.
   - `maintenance-proposal.md` — post-handover SLA offer with Basic/Standard/Premium tiers, severity matrix, SLA exclusions.

2. **One new meta-playbook** under `docs/playbooks/`:
   - `solo-dev-client-delivery.md` (Lifecycle: experimental). Pointers-only. Maps a 12-stage commercial flow onto existing harness pieces. Honors `playbook-composition-pattern.md` — composes, does not duplicate.

3. **Vietnamese locale fork starter** under `docs/templates/locale-vi/`:
   - All 5 new commercial templates.
   - Existing client-facing closure templates: `delivery-closure-story/{01-uat-plan,02-signoff,03-client-update}.md` and `project-closure-story/01-handover-docs.md`.
   - Internal templates (story, decision, spec-intake, high-risk-story, validation-report, closure overviews, credentials handover, knowledge transfer) stay English-only.

4. **Story template addendum:** add § Implementation Guardrails to `docs/templates/story.md` (scope discipline, no architecture change without decision, deletion proof, state handling for UI, input validation at boundary, commit must cite REQ/SC token).

5. **Index updates:**
   - New `docs/templates/README.md` listing all templates grouped by story / closure / commercial, with localization notes.
   - `docs/playbooks/README.md` adds the meta-playbook row in the workflow-recipe group.
   - `docs/playbooks/bilingual-delivery-template-pattern.md` adds § Current Locale Forks In This Harness documenting what was shipped.

6. **Backlog hygiene:** add and immediately mark accepted in `docs/HARNESS_BACKLOG.md` the five capability entries that justified this decision; cite this decision.

## Alternatives Considered

1. **Wait for friction per the standard promotion rule.** Rejected — the rule is calibrated for harness-improvement proposals discovered in isolation; here a single project will independently hit all 5 gaps in a 4-6 week window with a paying client. Waiting means inventing artifacts under deadline pressure with no review cycle.

2. **Ship the templates but skip the `locale-vi/` fork** (force the project install to translate). Rejected — the solo dev is the only resource on the project; translation under deadline is the kind of work that ships sloppy and stays sloppy.

3. **Ship templates + full bilingual fork including internal templates** (story.md, decision.md, etc.). Rejected — internal templates are agent-facing, not client-facing. Translating them creates dialect drift (per `bilingual-delivery-template-pattern.md` § Anti-Patterns). Internal artifacts stay English.

4. **Replace harness flow with the source doc's 15-stage flow.** Rejected — the source doc is a prompt-driven LLM-generation workflow; the harness is an artifact-driven living-contract workflow. The source's prompts produce vibe output that rots; harness artifacts persist as the living contract. Borrow the *commercial gaps*, keep the harness's *delivery discipline*.

5. **Adopt prompts from the source doc as harness scaffolds.** Rejected — prompts are not artifacts. The harness stays artifact-driven.

## Consequences

Positive:

- The solo-dev VN e-commerce project can run end-to-end through the harness without inventing commercial artifacts under deadline.
- Client-facing communication has consistent shape across stages (SOW § 9, CR § Reply Templates, Release § 11, Closure 03-client-update).
- Payment risk is bounded by milestone-gated SOW + retention payment until handover complete.
- Scope-creep risk is bounded by SOW § 9 + change-request-log + 5 reply templates.
- Post-handover support is bounded by maintenance-proposal SLA exclusions and tier hours.
- The harness now has a coherent solo-dev story (12 stages, pointers-only meta-playbook) without inflating Task Loop ceremony for non-commercial work.
- The VN starter fork demonstrates the bilingual pattern with a real example, making future locale forks easier.

Tradeoffs:

- Five templates shipped on weak demand evidence (1 project, not 2). Mitigated by: (a) all five composed by one meta-playbook so the marginal cost of an unused template is one README row; (b) post-first-use review will surface which templates need amendment (per playbook-lifecycle promotion rule); (c) any unused template can be deprecated quickly if the next 2-3 projects do not exercise it.
- Locale-vi starter biases the harness toward VN. Mitigated by: (a) starter covers only client-facing surface (9 files), not the full template inventory; (b) internal templates stay English; (c) other locales emerge as forks when needed (the bilingual pattern is explicit about this).
- Story template now has 6-line § Implementation Guardrails section that every story carries. Mitigated by: the guardrails are universal (not project-specific), the section is short, and the rules are ones a competent reviewer would enforce anyway.
- Meta-playbook risks becoming a substitute for reading the underlying playbooks. Mitigated by: meta-playbook is explicitly pointers-only (no duplicated content) and contains a § When This Playbook Conflicts With The Harness section reinforcing the source-of-truth hierarchy.

## Follow-Up

- After the first real solo-dev VN e-commerce project closes, run `docs/playbooks/session-retrospective.md` on the full project (not per-session). Capture which templates were edited heavily, which were not used, which exposed a missing field. Append Variant sections per playbook as needed.
- If the meta-playbook is used without modification on 1 real project, promote `solo-dev-client-delivery.md` from `experimental` to `verified` (per `docs/HARNESS.md` § Playbook Lifecycle).
- If 2+ projects independently exercise the VN fork, consider promoting the bilingual pattern itself from `experimental` to `verified`.
- If a second locale request arrives (JP, EN-other), apply the same pattern; do NOT pre-translate without demand.
- The 6 internal templates that did NOT fork to VN (story, decision, spec-intake, high-risk-story, validation-report, closure overviews/internal) may need VN forks later. Defer the decision to actual project friction.

## Related

- `plans/reports/xia-260517-1538-solo-dev-vibecode-vs-harness.md` — source compare audit.
- `docs/decisions/0005-roadmap-execution-direction.md` § 5 — promotion rule deviated from here; deviation rationale in § Context above.
- `docs/decisions/0004-adopt-claudekit-custom-patterns.md` — bilingual pattern source.
- `docs/playbooks/solo-dev-client-delivery.md` — the new meta-playbook this decision authorizes.
- `docs/playbooks/bilingual-delivery-template-pattern.md` — locale fork rules followed.
- `docs/playbooks/playbook-composition-pattern.md` — composition rules followed.
