# Solo-Dev Client Delivery Playbook

**Lifecycle:** experimental · **First use:** TBD · **Verified by:** none

> Meta-playbook for solo developers (or small teams) delivering paid work to clients with the harness. Maps each commercial stage to existing harness artifacts. **Pointers only — no new mechanics.** Honor `playbook-composition-pattern.md`: this composes, it does not duplicate.

## When To Run

- First time using the harness for a paid client project.
- Re-orienting at any stage during an active client project ("where am I in the flow, what do I owe next?").
- Onboarding a new collaborator into the commercial side of a project.

Skip when:

- The project is internal / OSS / hobby — most commercial wrappers are noise. Use the harness directly from `docs/FEATURE_INTAKE.md`.
- The project is mid-flight and the team already has a working delivery cadence — do not retrofit ceremony.

## The Flow

Twelve stages. Each stage points to ONE primary artifact and 0-2 supporting playbooks.

```text
[1. Lead] → [2. Intake brief] → [3. Discovery] → [4. Proposal/SOW] →
[5. Spec intake + Design intake] → [6. Story slicing] → [7. Build]
  → [8. Code review] → [9. QA + scenarios] → [10. UAT + signoff]
  → [11. Release + client update] → [12. Handover + maintenance]
```

### 1. Lead

A potential client reaches out. Capture the conversation in any form (email thread, chat log, meeting notes). No artifact yet.

### 2. Intake brief

Vendor-internal one-pager: should we take this project?

- **Artifact:** `docs/templates/client-intake-brief.md` (`locale-vi/` fork if client-facing).
- **Decide:** proceed-to-discovery / proceed-with-conditions / park / decline.
- **Output:** a saved brief at `docs/intake/YYYY-MM-DD-<client-slug>.md`.

If declining, send the polite reply (§ 15 of the brief) and stop.

### 3. Discovery

Structured conversation to surface REQs, decisions, and open questions before pricing.

- **Artifact:** `docs/playbooks/discovery-interview-playbook.md` (5 personas × 3 modes).
- **Output:** REQ list, decisions log, open questions list. Save to `docs/intake/YYYY-MM-DD-<client-slug>-discovery.md`.
- **Time-box:** 60-90 min for spec intake; 20-30 min for change requests.

### 4. Proposal & SOW

Convert the discovery output into a priced commercial proposal.

- **Artifact:** `docs/templates/proposal-sow.md` (`locale-vi/` fork for client-facing).
- **Critical sections:** § 4 in-scope, § 5 out-of-scope, § 7 milestones, § 8 payment schedule, § 9 change-request policy, § 10 acceptance conditions.
- **Gate:** signed SOW + deposit before any code is written.

### 5. Spec intake + Design intake

After signing, derive harness artifacts from the spec.

- **Artifact:** `docs/templates/spec-intake.md`. Triggers `docs/product/*` derivation.
- **Gate:** human approves the intake before Phase 2 (`docs/FEATURE_INTAKE.md` § Spec Approval Gate).
- **UI projects also run:** `docs/playbooks/ui-design-system-contract.md` § Style Intake (5 sources). Produce `docs/decisions/YYYY-MM-DD-design-direction.md` then `docs/design-guidelines.md`.
- **High-risk projects also write:** `docs/decisions/NNNN-stack-selection.md` (per `docs/ARCHITECTURE.md` § Discovery Before Shape).

### 6. Story slicing

Cut product surface into story-sized work.

- **Artifact:** `docs/stories/epics/EXX-name/US-NNN-name.md` (from `docs/templates/story.md`). High-risk lane uses `docs/templates/high-risk-story/`.
- **Tokens:** every REQ becomes `US-NNN.REQ-MMM`. Every test scenario becomes `US-NNN.SC-MMM`.
- **Scenario decomposition:** for each REQ, run `docs/playbooks/scenario-taxonomy-playbook.md` (12 dimensions).

### 7. Build

Execute the story. Honour the story's § Implementation Guardrails section.

- **Artifact:** the code itself + commits referencing the story / REQ tokens.
- **Discipline:** don't change architecture without a new decision doc. Don't delete code without justification. Handle loading / error / empty states for any UI surface. Explain what changed in the commit body.
- **Rule:** every commit cites at least one `US-NNN.REQ-MMM` or `US-NNN.SC-MMM` token in the message.

### 8. Code review

Per-tier rubric.

- **Artifact:** `docs/playbooks/code-review-scoring.md` (6-dim, pass threshold ≥ 7, any 0 auto-blocks).
- **Application:** tiny = optional, normal = 1 reviewer, high-risk = 2 reviewers.

### 9. QA + scenarios

Prove the story behaves.

- **Artifacts:** `docs/TEST_MATRIX.md` rows citing `US-NNN.TC-MMM`; `docs/playbooks/canonical-e2e-flow-playbook.md` for user-journey tests.
- **Bug-for-tutorial flow:** `docs/playbooks/e2e-qa-field-by-field-verify-with-report.md` when the same artifact must also serve as a user-guide demo.
- **Rule:** every `REQ` cited in a story must trace to at least one `TC` row in TEST_MATRIX before UAT.

### 10. UAT + signoff

Client-facing acceptance gate. This is where harness rigor meets commercial reality.

- **Artifacts (English defaults; `locale-vi/` for client deliverables):**
  - `docs/templates/delivery-closure-story/overview.md` — wrapper story.
  - `docs/templates/delivery-closure-story/01-uat-plan.md` — TC table with ≤ 40 cases.
  - `docs/templates/delivery-closure-story/02-signoff.md` — REQ coverage + exclusions + conditions.
  - `docs/templates/delivery-closure-story/03-client-update.md` — message sent to the client.
- **Gate:** REQ coverage complete (every `US-NNN.REQ-MMM` either passed or explicitly excluded with a decision link).

### 11. Release + client update

Production deploy + structured client communication.

- **Artifact:** `docs/templates/release-note.md` (`locale-vi/` fork for client-facing).
- **Sub-checklists in the template:** § 7 pre-deploy checklist, § 8 post-deploy smoke, § 9 rollback plan, § 11 client-update message.
- **Rule:** every released REQ token appears in the release note. Every deferred REQ links to a follow-up story or backlog row.

### 12. Handover + maintenance

End-of-project ownership change + recurring revenue offer.

- **Artifacts (English defaults; `locale-vi/` for client deliverables):**
  - `docs/templates/project-closure-story/overview.md` — wrapper.
  - `docs/templates/project-closure-story/01-handover-docs.md` — index of read-this-order.
  - `docs/templates/project-closure-story/02-credentials-handover.md` — vault-pointer credentials checklist (no raw secrets).
  - `docs/templates/project-closure-story/03-knowledge-transfer.md` — sessions log.
- **Then:** send `docs/templates/maintenance-proposal.md` (`locale-vi/` fork). Defines SLA, tiers, and post-warranty support process.

## Always-On: Change Request

Independent of stage. Any client request that lands after SOW signing enters the log.

- **Artifact:** `docs/templates/change-request-log.md` (`locale-vi/` fork for client visibility).
- **Trigger:** new request from any channel. Even verbal asks.
- **Process:** classify (bug / change-request / new-feature / ux-improvement / clarification) → in-scope check → effort estimate (if non-bug) → reply using template (§ Reply Templates).

## Always-On: Audit Trail

- Every signed-off REQ has at least one TC row in `docs/TEST_MATRIX.md`.
- Every deviation from SOW lives in `docs/templates/change-request-log.md`.
- Every architecture change has a `docs/decisions/NNNN-*.md`.
- Every multi-task session ends with `docs/playbooks/session-retrospective.md` written to `plans/reports/retro-<date>-<slug>.md`.

## Decision Matrix — Which Templates Apply

| Project type | Intake brief | SOW | Spec intake | Design intake | High-risk story | Maintenance |
| --- | --- | --- | --- | --- | --- | --- |
| Landing page (Low) | yes | yes | optional | yes | no | optional |
| Web app / SaaS (Medium) | yes | yes | yes | yes | optional | yes |
| Internal tool / automation (Medium) | yes | yes | yes | optional | optional | yes |
| AI app (Medium) | yes | yes | yes | optional | yes (if user-data) | yes |
| E-commerce / Dashboard (High) | yes | yes | yes | yes | yes | yes |
| Mobile (Medium-High) | yes | yes | yes | yes | optional | yes |

## When This Playbook Conflicts With The Harness

The harness wins. This playbook is a *commercial wrapper around* the harness — when a step here implies skipping a harness rule, the harness rule applies. Specifically:

- Cannot skip `docs/FEATURE_INTAKE.md` § Spec Approval Gate even under timeline pressure.
- Cannot skip stack-selection decision (`docs/ARCHITECTURE.md` § Discovery Before Shape) before the first implementation story.
- Cannot skip `docs/playbooks/code-review-scoring.md` for normal/high-risk lanes even when the client is "fine without review".
- Cannot replace `docs/TEST_MATRIX.md` with "UAT will catch it" — UAT TCs cite matrix rows; the matrix is the source of truth.

## Variant Section

(Append a Variant block here when this playbook fails or partially works. Do not delete the original shape.)

## Related

- `docs/playbooks/playbook-composition-pattern.md` — composition rules this playbook honors.
- `docs/playbooks/bilingual-delivery-template-pattern.md` — locale fork pattern used by the client-facing artifacts above.
- `docs/playbooks/discovery-interview-playbook.md` — stage 3.
- `docs/playbooks/scenario-taxonomy-playbook.md` — stage 6.
- `docs/playbooks/canonical-e2e-flow-playbook.md` — stage 9.
- `docs/playbooks/code-review-scoring.md` — stage 8.
- `docs/playbooks/ui-design-system-contract.md` — stage 5 (UI projects).
- `docs/playbooks/session-retrospective.md` — end-of-session capture.
- `docs/templates/proposal-sow.md`, `client-intake-brief.md`, `maintenance-proposal.md`, `release-note.md`, `change-request-log.md` — new commercial templates this playbook chains.
- `docs/templates/delivery-closure-story/`, `project-closure-story/` — closure templates this playbook chains.
- `docs/decisions/0007-solo-dev-client-delivery-templates.md` — adoption decision.
