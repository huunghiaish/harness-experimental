# Release Note — <version or release name>

Date: YYYY-MM-DD · Environment: dev | staging | production
Build / commit: <git sha> · Previous release: <version or tag>

> Generated at each release. Sits between UAT (`docs/templates/delivery-closure-story/01-uat-plan.md`) and the client update (`03-client-update.md`).

## 1. Release Summary

One paragraph: what shipped in this release and why. Tie to the milestone in `docs/templates/proposal-sow.md` § 7 if applicable.

## 2. New Features

| # | Feature | REQ token | Story | Client-visible? |
| --- | --- | --- | --- | --- |
| F1 | <feature> | `US-NNN.REQ-001` | `docs/stories/.../US-NNN-name.md` | yes |
| F2 | <feature> | `US-MMM.REQ-002` | `docs/stories/.../US-MMM-name.md` | yes |

## 3. Bug Fixes

| # | Issue | Severity | Story / commit |
| --- | --- | --- | --- |
| B1 | <one-line bug> | S2 | `<story or commit>` |

## 4. Improvements (Non-Behavioral)

Items that touch the codebase but do not change product behavior — performance, refactor, dependency bump, docs.

- <improvement>

## 5. Breaking Changes

If any. Otherwise write "None".

| Change | Affects | Migration step |
| --- | --- | --- |
| API endpoint X moved to /v2 | client integration | update client to /v2 by YYYY-MM-DD |

## 6. Known Issues

Issues we accepted shipping with. Link each to a backlog row or follow-up story.

- <issue> — `docs/HARNESS_BACKLOG.md` row or `docs/stories/...`

## 7. Deployment Checklist (Pre-Deploy)

- [ ] All tests pass on staging (link to test run).
- [ ] Database migration tested on a staging clone of prod data.
- [ ] Backup of prod DB taken within last 4 hours.
- [ ] Feature flags ready (default OFF for risky features).
- [ ] Environment variables for new integrations added to prod secret store.
- [ ] Third-party services notified (if integration changes).
- [ ] Deploy window communicated to client.
- [ ] Rollback path tested (see § 9).
- [ ] On-call / contact available during deploy window.

## 8. Post-Deploy Smoke Checklist

Run within 30 minutes of deploy. Each item must pass before declaring release green.

- [ ] Homepage loads (200, < 3s).
- [ ] Login flow works (test account, both happy + invalid).
- [ ] Core action of this release works end-to-end on prod data (cite the journey from `01-uat-plan.md` § Journey).
- [ ] No new error-rate spike in monitoring (compare to 1h pre-deploy baseline).
- [ ] No new alert-rule firing.
- [ ] Payment flow processes a real or sandbox transaction (e-commerce / SaaS only).
- [ ] Background job processes a sample event (queue / cron / webhook only).
- [ ] Logs from new code path are visible in monitoring.

## 9. Rollback Plan

| When to rollback | How |
| --- | --- |
| Post-deploy smoke fails on a critical item (login, payment, homepage) | Run `<rollback command or script>`. Estimated time: <N> minutes. |
| Error rate > <threshold> within 1 hour | Same as above. Notify client per § 11. |
| Data corruption detected | Stop writes (`<command>`), restore from backup (§ 7 backup), root-cause before reapplying. |

Rollback steps:

1. <step>
2. <step>
3. Re-run smoke checklist (§ 8).
4. Notify client (§ 11).

## 10. Verification After Rollback

- [ ] Production points to previous release (verify by version-endpoint or git sha header).
- [ ] Smoke checklist (§ 8) passes again on the rolled-back version.
- [ ] Post-incident note logged at `docs/incidents/YYYY-MM-DD-<slug>.md`.
- [ ] Follow-up story created for the failed release: `docs/stories/.../US-NNN-rerelease-X.md`.

## 11. Client Update Message

Sent through the agreed channel (email / Telegram / Slack) within <N> hours of deploy. Use the template at `docs/templates/delivery-closure-story/03-client-update.md` and inject the summary from § 1 here.

Draft:

```text
Subject: <project> release <version> deployed

Hi <client>,

We deployed <version> to production at <time>. This release includes:

- <one-line feature 1>
- <one-line feature 2>
- <count> bug fixes

Production URL: <url>
What you may want to verify: <client-action items>

Known issues (already in the backlog, not blocking):
- <issue>

If you see anything unexpected, reply to this thread.

— <vendor name>
```

## 12. Sign-Offs

| Role | Name | Confirmed by |
| --- | --- | --- |
| Vendor — deployer | <name> | git sha + timestamp |
| Vendor — verifier | <name> | smoke checklist passed |
| Client (if pre-prod gate required) | <name> | UAT signoff link |

---

**Pointers**

- UAT plan that gates this release: `docs/templates/delivery-closure-story/01-uat-plan.md`.
- Signoff record: `docs/templates/delivery-closure-story/02-signoff.md`.
- Client update template: `docs/templates/delivery-closure-story/03-client-update.md`.
- Change requests that landed in this release: `docs/templates/change-request-log.md` (filter by release tag).
- Localization: forks to `docs/templates/locale-vi/release-note.md`.
