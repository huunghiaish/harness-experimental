# Role-Permission Matrix — <project name>

Status: draft | reviewed-by-client | accepted · Last updated: YYYY-MM-DD

> Frozen at the end of stage 6 (Visual & Behavioral Modeling) per `docs/playbooks/solo-dev-client-delivery.md`. Lives at `docs/visuals/diagrams/role-permission-matrix.md` in the project repo. Re-checked during UAT.
>
> Captures who-can-do-what before code. Catches authorization holes that are 10x cheaper to fix in the matrix than in production audit logs.

## Roles

| Role | One-line scope | Notes |
| --- | --- | --- |
| guest | Unauthenticated visitor | Public surfaces only. |
| customer | Authenticated end-user | Owns own data. |
| staff | Operational user | Reads everyone's data; writes within their unit. |
| admin | Tenant administrator | Manages staff and config inside one tenant. |
| superadmin | Cross-tenant operator | Vendor / platform owner. |

Adapt to the project. Map every project-specific title (Product Owner, Manager, Cashier, etc.) to one of the rows above, OR add a new row if truly distinct. A role with no distinct permission grid is not a role — collapse it.

## Resources

List every entity / surface that has permission semantics. One row per resource.

| Resource | One-line description |
| --- | --- |
| account | The actor's own user record |
| product | Catalog item |
| order | Customer purchase |
| ... | ... |

## Permission Grid

Permission values: `Y` = full · `O` = own-only · `N` = none · `C` = conditional (cite condition below).
Actions: C = Create, R = Read, U = Update, D = Delete. Add custom actions as columns (e.g. `Refund`, `Approve`).

| Resource | Role | C | R | U | D | Custom: <action> | Citation |
| --- | --- | --- | --- | --- | --- | --- | --- |
| account | guest | N | N | N | N | — | — |
| account | customer | N | O | O | O | — | `US-NNN.REQ-001` |
| account | staff | N | Y | C¹ | N | — | `US-NNN.REQ-002` |
| account | admin | Y | Y | Y | C² | — | `US-NNN.REQ-003` |
| product | guest | N | Y | N | N | — | `US-NNN.REQ-004` |
| product | customer | N | Y | N | N | — | `US-NNN.REQ-004` |
| product | staff | Y | Y | Y | C³ | — | `US-NNN.REQ-005` |
| order | customer | Y | O | C⁴ | N | — | `US-NNN.REQ-006` |
| order | staff | N | Y | Y | N | `Refund: Y` | `US-NNN.REQ-007` |

## Conditions

Each `C` in the grid cites a numbered condition.

1. Staff can update an account only when an active support ticket links staff to that account.
2. Admin can delete an account only after a 30-day grace period and only if the account has no open orders.
3. Staff can delete a product only if no order references it; otherwise soft-delete (set `archived=true`).
4. Customer can update an order only while status is `pending`. Beyond that, change-request flow.

## Authentication Requirements

| Surface | Auth required | Re-auth required |
| --- | --- | --- |
| Browse catalog | no | — |
| Add to cart | no | — |
| Checkout | yes | re-auth if order > <threshold> |
| Admin dashboard | yes | re-auth on every session |
| Account deletion | yes | re-auth + 2FA |

## Audit Requirements

Every mutation flagged below produces an audit log entry. Read access is generally not audited unless flagged.

| Resource × Action | Audited? | Retention |
| --- | --- | --- |
| account × U / D | yes | 7 years |
| order × C / U / refund | yes | 7 years |
| product × C / U / D | yes | 1 year |

## Token Coverage

Every row in § Permission Grid that has at least one non-`N` value cites a `US-NNN.REQ-MMM` token. Uncited rows are gaps — either add the REQ to a story or downgrade the row to `N`.

Coverage check (run before freezing):

- [ ] Every role appears in the grid (no missing role).
- [ ] Every resource appears in the grid (no missing resource).
- [ ] Every `C` has a numbered condition entry.
- [ ] Every non-`N` cell cites a `US-NNN.REQ-MMM`.
- [ ] § Authentication Requirements covers every authenticated surface.
- [ ] § Audit Requirements lists every retention-critical mutation.

## Change Log

Append-only. Track every grid edit after first client review.

| Date | Change | Reason | CR ID |
| --- | --- | --- | --- |
| YYYY-MM-DD | Added `Refund` custom action for staff × order | Client clarified during UAT | CR-NNN |

## Sign-Off

Frozen at:

- Stage 6 end (before story slicing) — initial freeze, vendor confirms internally.
- UAT — client confirms permission matrix matches actual product behavior.

| Stage | Date | Approver |
| --- | --- | --- |
| Stage 6 freeze | YYYY-MM-DD | <vendor lead> |
| UAT confirmation | YYYY-MM-DD | <client signoff name> |

---

**Pointers**

- Visual & behavioral modeling playbook: `docs/playbooks/visual-and-behavioral-modeling.md`.
- Story tokens: `docs/HARNESS.md` § Traceability Tokens.
- UAT cross-check: `docs/templates/delivery-closure-story/01-uat-plan.md`.
- Localization: forks to `docs/templates/locale-vi/role-permission-matrix.md`.
