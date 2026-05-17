# Change Request Log — <project name>

> One file per project. Append-only. Every client-initiated change after SOW signing enters this log — verbal asks, email tweaks, "small additions". No silent scope changes.
>
> Maps to `docs/FEATURE_INTAKE.md` "Change request" input type for the internal lane. This file is the **client-facing surface** that powers the SOW § 9 Change Request Policy.

## How To Use

1. Client raises a request through any channel.
2. Vendor logs it as a new row immediately (§ Log Table). Status: `new`.
3. Vendor classifies within <N> business days (§ Classification).
4. If in original scope → fix at no extra cost; status moves to `in-progress` then `done`.
5. If out of scope → vendor returns effort estimate + price (§ Estimate); status moves to `quoted`. Client approves → `accepted` → `in-progress`. Declined or deferred → `deferred` or `rejected`.
6. Reply to client using the message template (§ Reply Templates).

## Classification

| Type | Meaning | Default route |
| --- | --- | --- |
| `bug` | Behavior deviates from accepted spec or AC | In scope. Fix under warranty. |
| `change-request` | Modify in-scope behavior that was accepted | Effort-based: minor = absorb, major = quote |
| `new-feature` | New behavior not in original SOW § 4 | Out of scope. Quote separately. |
| `ux-improvement` | UX tweak (copy, layout, flow polish) | Quote unless trivial (< 30 min) |
| `clarification` | Question about existing behavior | Free. Answer + link to spec. |

When ambiguous, lean toward `change-request` or `new-feature` and let the client push back. Logging more is safer than logging less.

## Severity (for bugs only)

Use the same scale as `docs/templates/maintenance-proposal.md` § 6.

| | |
| --- | --- |
| S1 | Production unusable, data loss, payment broken |
| S2 | Core feature broken, workaround exists |
| S3 | Cosmetic, minor |

## Effort Estimate (for non-bug)

| Tag | Hours | Typical work |
| --- | --- | --- |
| XS | < 1h | Copy change, color tweak |
| S | 1-4h | Single field, validation rule, minor UI |
| M | 4-16h | New screen using existing components |
| L | 16-40h | New flow with backend changes |
| XL | > 40h | Triggers a phase-2 SOW conversation, not a CR |

## Log Table

| CR ID | Date raised | Source | Description (one line) | Classification | Severity | In-scope? | Effort | Status | Released in | Reply sent |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| CR-001 | YYYY-MM-DD | <email/call/chat> | <one-line> | `change-request` | — | no | S | quoted | — | YYYY-MM-DD |
| CR-002 | YYYY-MM-DD | <source> | <one-line> | `bug` | S2 | yes | — | done | v1.1 | YYYY-MM-DD |
| CR-003 | YYYY-MM-DD | <source> | <one-line> | `new-feature` | — | no | M | deferred | phase-2 | YYYY-MM-DD |

Status values: `new` · `classified` · `quoted` · `accepted` · `in-progress` · `done` · `deferred` · `rejected`

## Per-CR Detail (when L+ effort or disputed)

For any CR estimated L+, or any CR where the client disagrees with the classification, expand below. XS / S CRs can live as a single log row.

### CR-NNN: <title>

- **Raised**: YYYY-MM-DD via <source>
- **Verbatim request**: > "<paste client's exact words>"
- **Classification**: <type> — <one-line reason>
- **In original SOW**: yes / no (cite SOW § 4 line if "yes")
- **Affected modules / stories**: `docs/stories/.../US-NNN-name.md`, `docs/product/...`
- **Effort estimate**: <tag> (<hours> hours)
- **Price** (if out of scope): <amount>
- **Risk if accepted**: <impact on timeline / other features>
- **Recommendation**: do now / defer to phase 2 / decline
- **Decision date**: YYYY-MM-DD
- **Decided by**: <client name>
- **Released in**: <release tag>

## Reply Templates

Use these as starting points; adjust tone to the client relationship.

### Reply A — In-scope bug (will fix at no cost)

```text
Subject: Re: <client's wording> — confirmed bug, fixing

Hi <client>,

Logged as CR-NNN. This deviates from the spec we accepted, so it's a bug
under warranty. Targeting fix in <release tag, target date>.

I'll update CR-NNN's status when the fix is on staging.

— <vendor>
```

### Reply B — Change request (out of scope, here's the quote)

```text
Subject: Re: <client's wording> — change request CR-NNN

Hi <client>,

I'd be happy to do this. It's outside the original scope (SOW § 4), so
sharing the estimate:

- What changes: <one-line>
- Effort: <tag> (<hours> hours)
- Price: <amount>
- Earliest delivery: <date> (this shifts <other deliverable> by <impact>)

Reply with "approved" to start, or let me know if you'd like to defer to
a phase-2 batch (smaller per-CR price when batched).

— <vendor>
```

### Reply C — New feature (defer to phase 2)

```text
Subject: Re: <client's wording> — recommend phase 2

Hi <client>,

This is a new feature, not a bug or tweak. Doing it now would shift M3
by about <impact>, which we both agreed to protect.

Suggestion: park CR-NNN for a phase-2 batch (post-M5). I'll keep a list
and we can decide together after launch — by then you'll also have user
feedback to prioritize against.

If it's actually urgent (revenue-critical, regulatory), reply and I'll
re-estimate including the timeline impact.

— <vendor>
```

### Reply D — Clarification (free, point to spec)

```text
Subject: Re: <client's wording> — clarification

Hi <client>,

Quick answer: <one-line>. This is the accepted behavior per <SOW section
or story link>.

Logged as CR-NNN with status `done — clarification`. If you'd like to
change this behavior, let me know and I'll re-classify.

— <vendor>
```

### Reply E — Severity 1 incident

```text
Subject: URGENT — <issue> — CR-NNN

Hi <client>,

Acknowledged at <timestamp>. Investigating now.

Current impact: <user-facing impact, blast radius if known>
Workaround for now: <if any, else "none — investigating">
Next update: within <N> hours

— <vendor>
```

## Audit Rules

- Append-only. Never delete a row; if a CR was misclassified, add a follow-up row referencing the original.
- A CR is **closed** only when status is `done`, `deferred`, or `rejected` AND a reply has been sent (timestamp in last column).
- At each release, fill the "Released in" column for every `done` CR.
- At project closure (`docs/templates/project-closure-story/`), report open `deferred` CRs as phase-2 candidates.

---

**Pointers**

- Internal lane: `docs/FEATURE_INTAKE.md` § Input Types — Change request.
- SOW § 9 Change Request Policy: `docs/templates/proposal-sow.md`.
- Maintenance SLA for response windows: `docs/templates/maintenance-proposal.md` § 5.
- Localization: forks to `docs/templates/locale-vi/change-request-log.md`.
