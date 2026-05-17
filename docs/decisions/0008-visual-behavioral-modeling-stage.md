# 0008 Visual & Behavioral Modeling Stage Inserted Into Solo-Dev Client Delivery

Date: 2026-05-17

## Status

Accepted

## Context

`docs/decisions/0007-solo-dev-client-delivery-templates.md` (same day) shipped a 12-stage meta-playbook for solo-dev paid client delivery. Within the same session, the user surfaced a structural gap based on real-project experience: between design-token intake (stage 5) and story slicing (stage 6 in 0007's numbering), there was no explicit phase for producing the visual + behavioral artifacts that:

1. Anchor non-tech client review BEFORE code (catches scope/UX disputes at UAT, where they are expensive).
2. Serve as the AI code-generation handoff target (without a pixel-anchored target, AI build drifts).
3. Establish the legal authorization + state-machine contract (without these, permission and state bugs surface in production audit logs).

The user identified Claude Design (https://claude.ai/design) as the primary tool with native "handoff to Claude Code" — strong fit for solo-dev throughput. Fallback ladder includes Google Stitch (`/stitch` skill), Claude Artifacts, v0.dev, pencil.dev / penpot, Figma + AI plugins, and last-resort `/frontend-design` hand-writing.

The harness already had `docs/playbooks/ui-design-system-contract.md` covering design tokens and a Component Coverage Matrix, but no playbook for generating actual interactive prototypes from those tokens. It also had no template for Role-Permission Matrix or Status Flow — two of the highest-leverage behavioral artifacts. ERD draft, user flow, and business workflow can be expressed with existing Mermaid skill but had no canonical home.

A real VN e-commerce / dashboard project is running through this harness end-to-end in the same week (see 0007 § Context), exposing the gap with immediate cost.

## Decision

Insert a new stage between current stage 5 (Spec + Design intake) and current stage 6 (Story slicing) in `docs/playbooks/solo-dev-client-delivery.md`. Renumber subsequent stages 6-12 → 7-13. Ship:

1. **New playbook** — `docs/playbooks/visual-and-behavioral-modeling.md` (Lifecycle: experimental). Workflow recipe with 3 sub-steps:
   - **A. Design system check** — points to existing `ui-design-system-contract.md`, no duplication.
   - **B. Interactive prototype** — tool ladder with Claude Design (https://claude.ai/design) as rank 1, Stitch / Artifacts / v0.dev / pencil.dev / hand-write as fallbacks. Output under `docs/visuals/prototype/`. Triple-use rule documented.
   - **C. Business diagrams** — 6 diagrams in `docs/visuals/diagrams/`: sitemap, user flow per journey, business workflow per multi-role process, ERD draft, role-permission matrix, status flow per stateful entity.

2. **Two new templates** — `docs/templates/role-permission-matrix.md` and `docs/templates/status-flow.md`, both with `locale-vi/` forks (client-facing during review and UAT).

3. **Meta-playbook update** — `solo-dev-client-delivery.md` flow ASCII, stage numbering (6-12 → 7-13), Decision Matrix table (new column "Visual modeling"), conflict-with-harness section (new rule on prototype freeze), Related section.

4. **Index updates** — `playbooks/README.md` and `templates/README.md` (new "Visual & behavioral modeling templates" group).

5. **Backlog hygiene** — add accepted entry citing this decision.

6. **Installer sync** — `scripts/install-harness.sh` heredoc gains the 5 new files (1 playbook, 2 templates EN, 2 templates VN, this decision).

Stage 6 application rules (in the playbook):

- Tiny lane: skip whole stage.
- Normal lane: sub-step A + sitemap + at least 1 user flow + 1 prototype screen per client-visible surface. RPM + Status Flow optional.
- High-risk lane: all sub-steps required; RPM + Status Flow required per stateful entity.

## Alternatives Considered

1. **Expand stage 5 to absorb visualization instead of adding stage 6.** Rejected — stage 5 is "intake" (deriving harness contracts from a signed spec); stage 6 produces NEW visual artifacts the client will literally review. Conflating intake with prototype review muddles two different gates and makes per-tier scoping harder (a high-risk project may need stage 5 + full stage 6; a tiny project may need stage 5 only).

2. **Skip the playbook, just document the templates.** Rejected — the templates alone do not capture the triple-use rule (client review + AI code handoff + UAT pass criterion) or the freeze-then-iterate-via-CR discipline. Those are the highest-leverage parts.

3. **Build a separate playbook per sub-step (one for prototype, one for diagrams).** Rejected for now — KISS / YAGNI. The 3 sub-steps run in sequence within a single stage; splitting into 3 playbooks would force the user to compose them every time. One workflow recipe is enough. If a sub-step grows beyond what one playbook can hold, split later via Variant + new playbook (per playbook-composition-pattern).

4. **Modify decision 0007 instead of writing a new decision.** Rejected — 0007 is shipped and committed (commit 22c0529). Retroactive edits to accepted decisions muddle the audit trail. Each named expansion of scope gets its own decision; 0008 references 0007 as prior.

5. **Hard-code Claude Design as the only tool.** Rejected — violates the harness's Independence Principle (no required external tool / SaaS). Ship a fallback ladder; document Claude Design as preferred but not gating. Projects with no Claude Design access drop to rank 2-6 without losing the stage.

## Consequences

Positive:

- Solo-dev VN e-commerce project gets the visualization-first discipline it needs without inventing artifacts at midstream.
- AI code generation has a stable visual target (frozen prototype) and a stable behavioral target (frozen RPM + status flow) — drift between spec and build collapses to a small surface.
- Client review happens on a clickable artifact, not a PRD — non-tech clients can actually give useful feedback.
- UAT gains a new pass criterion (visual conformance to frozen prototype) that is cheap to check and powerful in scope disputes.
- Permission and state bugs are now caught in matrix / flow files, not in production logs.
- Stage-6 artifacts become part of the handover (stage 13) automatically.

Tradeoffs:

- Renumbering stages 6-12 → 7-13 is mildly disruptive for anyone who already linked to specific stage numbers. Mitigated by: the meta-playbook only shipped 7 hours earlier (same day commit 22c0529); no production project has linked to its stage numbers yet.
- Adds a real cost to the timeline. For a high-risk project, stage 6 can take 1-2 days of dedicated work plus 1-2 review rounds with the client. Mitigated by: per-tier application (tiny skips, normal does a subset).
- Claude Design tool (https://claude.ai/design) may have limited availability or change in scope. Mitigated by: tool ladder with 6 ranks; rank-1 substitution is non-blocking.
- Two more templates (RPM, status flow) to keep in sync with their VN forks. Mitigated by: bilingual pattern already established for closure templates and other commercial templates; one more pair is cost-of-doing-business, not a step-change.
- Diagram + prototype that disagree is a real risk. Documented anti-pattern in the playbook with the reconcile-within-1-day rule.
- Prototype hosting / preservation past UAT requires discipline. Documented in playbook § Freeze Gate.

## Follow-Up

- After the first real solo-dev VN e-commerce project completes stage 6, run `session-retrospective.md` at the stage-6 scope. Capture: which sub-step was most expensive, which tool from the ladder was used, did the prototype freeze hold through to UAT, did the RPM catch any gaps. Append Variant sections to `visual-and-behavioral-modeling.md` per playbook lifecycle rules.
- If stage 6 + its playbook + its templates run on 1 real project without unwritten workarounds, promote `visual-and-behavioral-modeling.md` from `experimental` to `verified` (per `docs/HARNESS.md` § Playbook Lifecycle).
- If 2+ projects run stage 6 with consistent Claude Design as the chosen tool, document it more prominently. If 2+ projects run without Claude Design (using fallback ladder), shrink Claude Design's primacy in the playbook to match.
- Consider extracting `user-flow`, `business-workflow`, `erd-draft` into their own dedicated templates if multiple projects show the same shape friction. Currently they live as inline guidance under `docs/visuals/diagrams/`.
- Reassess the Decision Matrix table after 2-3 different project types have run stage 6 — adjust "yes / partial / no" calibrations to match real friction.

## Related

- `docs/decisions/0007-solo-dev-client-delivery-templates.md` — original commercial-wrapper decision; this decision expands its scope.
- `docs/playbooks/solo-dev-client-delivery.md` — meta-playbook updated by this decision.
- `docs/playbooks/visual-and-behavioral-modeling.md` — new stage-6 playbook authorized by this decision.
- `docs/playbooks/ui-design-system-contract.md` — sub-step A consumer.
- `docs/playbooks/playbook-composition-pattern.md` — composition rules followed.
- `docs/playbooks/bilingual-delivery-template-pattern.md` — locale fork rules followed for the 2 new templates.
- `docs/templates/role-permission-matrix.md`, `docs/templates/status-flow.md` — new templates authorized by this decision.
