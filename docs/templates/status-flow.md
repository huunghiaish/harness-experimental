# Status Flow — <entity name>

Status: draft | reviewed-by-client | accepted · Last updated: YYYY-MM-DD

> Frozen at the end of stage 6 (Visual & Behavioral Modeling) per `docs/playbooks/solo-dev-client-delivery.md`. One file per stateful entity (order, application, ticket, subscription, etc.). Lives at `docs/visuals/diagrams/status-flow-<entity>.md` in the project repo.
>
> Captures the legal state machine before code. Catches "user got stuck in state X because no transition leads out" defects before they ship.

## Entity

| | |
| --- | --- |
| Entity name | <e.g. order, application, ticket> |
| Owning resource | <e.g. orders table> |
| Stateful field | <e.g. `status` column> |
| Initial state | <e.g. `pending`> |

## States

Every state the entity can hold. A state with no inbound transitions is unreachable (delete). A state with no outbound transitions is terminal (mark as such).

| State | Description | Terminal? |
| --- | --- | --- |
| pending | Awaiting first action | no |
| in-review | Under staff review | no |
| approved | Approved, awaiting fulfillment | no |
| fulfilled | Delivered | yes |
| cancelled | Cancelled by customer or staff | yes |
| rejected | Rejected during review | yes |

## State Diagram (Mermaid)

```mermaid
stateDiagram-v2
    [*] --> pending
    pending --> in-review: customer submits
    pending --> cancelled: customer cancels
    in-review --> approved: staff approves
    in-review --> rejected: staff rejects
    approved --> fulfilled: ops ships
    approved --> cancelled: customer cancels (refund)
    fulfilled --> [*]
    cancelled --> [*]
    rejected --> [*]
```

Render via `docs/playbooks/headless-browser-blank-screenshot.md` or any Mermaid viewer. Update the diagram WHEN the transition table below changes — diagram and table are two views of the same fact.

## Transition Table

The canonical source. Every legal transition is one row.

| From | To | Trigger | Allowed role(s) | Pre-conditions | Side effects | Token |
| --- | --- | --- | --- | --- | --- | --- |
| pending | in-review | submit | customer | all required fields filled | notify staff via email | `US-NNN.REQ-001` |
| pending | cancelled | cancel | customer | — | no notification | `US-NNN.REQ-002` |
| in-review | approved | approve | staff | review notes filled | notify customer; charge payment hold | `US-NNN.REQ-003` |
| in-review | rejected | reject | staff | rejection reason filled | notify customer; release payment hold | `US-NNN.REQ-004` |
| approved | fulfilled | ship | staff | shipment confirmed | notify customer with tracking | `US-NNN.REQ-005` |
| approved | cancelled | cancel | customer, staff | within 24h of approval | refund payment in full | `US-NNN.REQ-006` |

Every transition row cites at least one `US-NNN.REQ-MMM`. Untokened rows are spec gaps — either add the REQ to a story or remove the row.

## Illegal Transitions

Pairs of states that look transitionable but are NOT allowed. Document explicitly to prevent silent bugs.

| From | To | Why blocked |
| --- | --- | --- |
| fulfilled | * | Fulfilled is terminal; returns route via a new entity (return-order). |
| cancelled | pending | No reactivation; customer creates a new entity. |
| rejected | in-review | No re-review; customer creates a new application. |

## Role × Action Cross-Check

Cross-reference with `docs/templates/role-permission-matrix.md` to ensure every trigger column above has matching grid coverage. A trigger callable by `staff` requires the staff row's relevant resource × action cell to be non-`N`.

- [ ] Every row's "Allowed role(s)" matches RPM grid.
- [ ] Every "Side effects" that mutates another entity (e.g. payment hold) is also reflected in that entity's permission grid.

## Audit Requirements

| Transition | Audited? | Retention |
| --- | --- | --- |
| Any transition into a terminal state | yes | 7 years |
| approved → cancelled (with refund) | yes | 7 years |
| pending → cancelled | optional | 1 year |

## Edge Cases & SLAs

| Case | Behavior | Time bound |
| --- | --- | --- |
| Stuck in `in-review` > 7 days | Auto-notify staff manager | 7 days |
| Stuck in `approved` > 3 days | Auto-cancel and refund | 3 days |
| Payment failure during in-review → approved | Roll back to in-review; flag for re-attempt | immediate |

## Coverage Check

Before freezing:

- [ ] Every state appears in § States table.
- [ ] Every state in the diagram appears in § Transition Table at least once (as From OR To).
- [ ] Every terminal state is marked `yes` in § States.
- [ ] Every transition cites a `US-NNN.REQ-MMM`.
- [ ] All allowed roles match `docs/templates/role-permission-matrix.md`.
- [ ] Illegal transitions enumerated.
- [ ] Edge-case SLAs defined for non-terminal states.

## Change Log

| Date | Change | Reason | CR ID |
| --- | --- | --- | --- |
| YYYY-MM-DD | Added `approved → cancelled` (within 24h) | Client business policy | CR-NNN |

## Sign-Off

| Stage | Date | Approver |
| --- | --- | --- |
| Stage 6 freeze | YYYY-MM-DD | <vendor lead> |
| UAT confirmation | YYYY-MM-DD | <client signoff name> |

---

**Pointers**

- Visual & behavioral modeling playbook: `docs/playbooks/visual-and-behavioral-modeling.md`.
- Role-Permission Matrix (cross-check): `docs/templates/role-permission-matrix.md`.
- Story tokens: `docs/HARNESS.md` § Traceability Tokens.
- UAT cross-check: `docs/templates/delivery-closure-story/01-uat-plan.md`.
- Localization: forks to `docs/templates/locale-vi/status-flow.md`.
