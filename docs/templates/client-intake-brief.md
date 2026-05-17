# Client Intake Brief — <client / project working title>

Date: YYYY-MM-DD · Status: review | accepted | declined | parked

> First pass after the initial conversation with a prospective client. Output is a vendor-internal one-pager that decides: do we proceed to discovery + proposal, or decline?
>
> Comes BEFORE `docs/templates/spec-intake.md` (which is the technical spec intake AFTER signing). Comes BEFORE `docs/templates/proposal-sow.md` (which needs scope clarity this brief surfaces).

## 1. Client

| | |
| --- | --- |
| Name | <person + company> |
| Channel | <referral / inbound / cold> |
| Decision-maker present? | yes / no — name |
| Existing vendor relationship? | none / past project: <ref> |

## 2. Stated Need (One Paragraph)

What the client said they want, in their own words (paraphrase if VN/EN mixed, but stay faithful).

## 3. Business Problem Behind The Need

What is the real problem the client is trying to solve? If only the "solution" was stated, ask in discovery.

## 4. Target Users

| Role | Count estimate | Primary task |
| --- | --- | --- |
| <role> | <NN> | <task> |

## 5. Requested Features (Raw)

Bullet list, exactly as expressed. Do not refine yet — refining is discovery's job.

- <feature>
- <feature>

## 6. Project Type

Tick one. Drives template depth and lane choice.

- [ ] Landing page / marketing site
- [ ] Web app (single-purpose)
- [ ] SaaS MVP (multi-tenant)
- [ ] Internal tool / admin panel
- [ ] Automation / workflow tool
- [ ] AI app (LLM-backed UX)
- [ ] E-commerce
- [ ] Dashboard / analytics
- [ ] Mobile app
- [ ] Other: ____

## 7. Complexity Estimate

Tick one. Drives lane (per `docs/FEATURE_INTAKE.md`).

- [ ] Low — single user role, no payment, no third-party integration beyond auth + email
- [ ] Medium — multi-role, simple payment OR 1-2 integrations, basic admin
- [ ] High — multi-tenant OR multi-role with permissions OR e-commerce checkout OR 3+ integrations OR data-sensitive (PII, finance, health)
- [ ] Very high — regulated industry, real-time / streaming, mobile + web parity, > 10 integrations

## 8. Timeline

| Item | Value |
| --- | --- |
| Client's stated deadline | YYYY-MM-DD |
| Reason behind deadline | <event / funding / season / arbitrary> |
| Vendor's feasibility read | realistic / tight / unrealistic |

## 9. Budget

| Item | Value |
| --- | --- |
| Stated budget range | <amount range, currency> |
| Vendor's read vs scope | adequate / underfunded / generous |
| Payment instrument confirmed | yes / no |

If "no stated budget" or "we'll see based on quote", flag in § 12 — proceeding without a range usually wastes both sides' time.

## 10. Red Flags

Tick all that apply. 2+ usually means decline or heavily renegotiate.

- [ ] Decision-maker not in the conversation
- [ ] Wants fixed price for unclear scope
- [ ] Compares to a much larger competitor product as "should be easy to copy"
- [ ] Multiple previous vendors mentioned ("the last guy quit")
- [ ] Budget < 30% of vendor's normal range for this type
- [ ] Deadline impossible regardless of budget
- [ ] Asks to skip contract / "just trust me"
- [ ] Wants to own vendor's reusable components
- [ ] Cannot articulate the business problem, only the solution
- [ ] Insists on a stack the vendor cannot maintain

## 11. Green Flags

- [ ] Has a clear business outcome metric
- [ ] Open to scope tradeoffs to fit budget/timeline
- [ ] Has existing assets ready (brand, content, sample data)
- [ ] Past project with vendor went well
- [ ] Willing to sign SOW and pay deposit before build
- [ ] Names a single decision-maker

## 12. Open Questions For Discovery

The questions vendor needs answered BEFORE producing `docs/templates/proposal-sow.md`. Group by topic to make the discovery call faster (use `docs/playbooks/discovery-interview-playbook.md` for shape).

- Business goal: <q>
- User & role: <q>
- Data: <q>
- Workflow: <q>
- Admin / permission: <q>
- Payment / billing: <q>
- Content / media: <q>
- Third-party integration: <q>
- Deadline / budget: <q>
- Success criteria: <q>

## 13. Initial Risk Read

| Risk | Likelihood | Impact | Mitigation if proceeding |
| --- | --- | --- | --- |
| Scope creep | <low/med/high> | <low/med/high> | Strong SOW § 9 + CR log |
| Payment delay | | | Milestone-gated payment in SOW § 8 |
| Content delays | | | Client responsibilities in SOW § 12 |
| Tech risk (unknown integration) | | | Spike during discovery before SOW |

## 14. Recommendation

Tick one.

- [ ] **Proceed to discovery** — schedule discovery call using `docs/playbooks/discovery-interview-playbook.md`. Then produce `docs/templates/proposal-sow.md`.
- [ ] **Proceed with conditions** — explicitly resolve <items> before discovery (e.g. budget range, decision-maker presence).
- [ ] **Park** — interesting but timing wrong (capacity, fit). Set a follow-up date: YYYY-MM-DD.
- [ ] **Decline** — does not pass the red-flag/budget/feasibility gate. Send a polite decline.

Reason for recommendation (one paragraph):

<text>

## 15. Decline / Park Reply (if applicable)

```text
Subject: <project> — appreciate the conversation

Hi <client>,

Thanks for the detailed brief. After thinking about it, I'm <not the
right fit / not able to take this on this quarter> because <one specific
reason — capacity / scope mismatch / domain fit>.

<If parking: I'd be glad to revisit after <date>. I'll reach out then.>
<If declining: a couple of options that might fit better: <referral or
self-serve tool>.>

Wishing the project well.

— <vendor>
```

---

**Pointers**

- Discovery interview: `docs/playbooks/discovery-interview-playbook.md` (5 personas × 3 modes).
- After discovery: `docs/templates/proposal-sow.md`.
- After SOW signed: `docs/templates/spec-intake.md` → `docs/product/*` derivation.
- Localization: forks to `docs/templates/locale-vi/client-intake-brief.md`.
