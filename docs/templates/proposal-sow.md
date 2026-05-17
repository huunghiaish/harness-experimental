# Proposal & Scope of Work — <project name>

Date: YYYY-MM-DD · Validity: <NN> days · Version: v0.1

> Client-facing single-page SOW. Read alongside `docs/templates/client-intake-brief.md` (the discovery pre-doc) and `docs/templates/spec-intake.md` (the technical intake that follows signing).

## 1. Client & Vendor

| | |
| --- | --- |
| Client | <client legal name + contact person> |
| Vendor | <vendor / solo-dev name + contact> |
| Effective date | YYYY-MM-DD |
| Estimated start | YYYY-MM-DD |
| Estimated delivery | YYYY-MM-DD |

## 2. Project Summary

One paragraph: what we are building, for whom, and why.

## 3. Goals & Success Criteria

- Business goal 1.
- Business goal 2.

Success metric (how the client will judge "done worked"):

- <metric>

## 4. Scope — In

Bullet list of features and deliverables included in the price. Group by epic if more than ~8 items.

- <feature>
- <feature>

## 5. Scope — Out (Explicitly Excluded)

Listing exclusions up-front prevents disputes. If a client asks for any of these, route via the Change Request process (§ 9).

- <excluded item>
- <excluded item>

## 6. Deliverables

| # | Deliverable | Format | When |
| --- | --- | --- | --- |
| D1 | Source code repo access | Git repo invite | At kickoff |
| D2 | Staging URL | Hosted link | Milestone M2 |
| D3 | Production deployment | Hosted link | Milestone M4 |
| D4 | Handover docs | `docs/handover/*` | Milestone M5 |
| D5 | Admin credentials | Vault reference | Milestone M5 |

## 7. Milestones & Timeline

| M# | Name | Output | Target date | Payment trigger |
| --- | --- | --- | --- | --- |
| M0 | Kickoff | Signed SOW + PRD-lite started | <date> | 30% deposit |
| M1 | Spec freeze | PRD-lite + UX spec + Tech spec accepted | <date> | — |
| M2 | Staging build | Core features on staging | <date> | 30% progress |
| M3 | UAT | UAT signoff (`docs/stories/.../delivery-closure/`) | <date> | — |
| M4 | Production | Production deploy + release note | <date> | 30% release |
| M5 | Handover | `docs/handover/*` complete | <date> | 10% retention |

Adjust the percentage split per project size. The retention payment protects the client during early production usage and forces the vendor to close handover properly.

## 8. Payment Terms

| Stage | Amount | Trigger |
| --- | --- | --- |
| Deposit | NN% | SOW signed |
| Progress | NN% | M2 staging accepted |
| Release | NN% | M4 production deployed |
| Retention | NN% | M5 handover complete |

- Currency: <e.g. VND, USD>
- Invoice cycle: <upon trigger / monthly>
- Late-payment grace: <N> days. After grace, work pauses until cleared.
- Payment instrument: <bank transfer / Stripe / etc.>

## 9. Change Request Policy

Any request outside § 4 enters the Change Request process (`docs/templates/change-request-log.md`):

1. Vendor classifies the request (bug / change / new feature / UX / clarification).
2. If in original scope → handled at no extra cost.
3. If out of scope → vendor returns effort estimate + price within <N> business days.
4. Client approves (or defers to a phase-2 SOW) before work starts.
5. No verbal changes — every CR enters the log.

## 10. Acceptance Conditions

The client accepts each milestone when:

- Deliverables in § 6 for that milestone exist and are accessible.
- UAT test cases for the milestone pass (per `docs/templates/delivery-closure-story/01-uat-plan.md`).
- Any open bug is logged and assigned a severity. Severity 1 (blockers) must be fixed before signoff; severity 2-3 can be deferred to a follow-up release.
- Signoff is recorded via `docs/templates/delivery-closure-story/02-signoff.md`.

Client has <N> business days from delivery notification to review and either accept or report issues. Silence past the window = deemed accepted.

## 11. Risks & Assumptions

| Type | Item | Mitigation |
| --- | --- | --- |
| Assumption | Client provides content/copy by M1 | Vendor uses placeholder if delayed; client accepts placeholder visible at staging |
| Assumption | Client provides domain + DNS access by M3 | Vendor delivers to a vendor-owned subdomain until access arrives |
| Risk | Third-party API rate limits or downtime | Vendor sets retry + fallback; SLA does not cover third-party outage |
| Risk | Scope creep past 10% of estimate | Each CR re-estimated; cumulative CR > 10% triggers phase-2 SOW conversation |

## 12. Client Responsibilities

- Provide a single decision-maker (or named escalation chain).
- Provide brand assets (logo, fonts, colors) by M1 — see `docs/playbooks/ui-design-system-contract.md` § Style Intake.
- Provide content/copy by M1 (or accept placeholder).
- Respond to vendor questions within <N> business days. Delayed answers shift the timeline 1:1.
- Provide credentials for third-party services (domain, email, payment, etc.) per `docs/templates/project-closure-story/02-credentials-handover.md`.

## 13. Warranty & Post-Delivery Support

- Bug warranty: <N> days from M4 production deploy. Bugs reproducible on production within the original scope are fixed at no extra cost.
- Out of warranty: change requests (§ 9), feature additions, and bugs caused by client modifications.
- Optional ongoing support: see `docs/templates/maintenance-proposal.md`.

## 14. Intellectual Property

- On final payment: <vendor transfers all source code and assets to client / vendor retains rights to reusable components, client receives perpetual license>.
- Vendor may showcase the project in a portfolio (anonymized or with client approval, choose one).
- Third-party libraries retain their original licenses.

## 15. Termination

Either party may terminate with <N> days notice. On termination:

- Vendor delivers all work-in-progress as-is.
- Client pays for work completed through termination date (pro-rated by milestone).
- IP transfer applies to delivered work only.

## 16. Signoff

| Party | Name | Title | Signature | Date |
| --- | --- | --- | --- | --- |
| Client | | | | |
| Vendor | | | | |

---

**Pointers**

- Next doc: `docs/templates/spec-intake.md` (after SOW signed → run spec intake to derive product docs).
- Closure doc: `docs/templates/delivery-closure-story/` (UAT, signoff, client update — at M3/M4).
- Handover doc: `docs/templates/project-closure-story/` (at M5).
- Change requests: `docs/templates/change-request-log.md`.
- Maintenance after delivery: `docs/templates/maintenance-proposal.md`.
- Localization: this template forks to `docs/templates/locale-vi/proposal-sow.md` per `docs/playbooks/bilingual-delivery-template-pattern.md`.
