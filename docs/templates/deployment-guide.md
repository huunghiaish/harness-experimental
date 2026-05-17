# Deployment Guide

> Stub. Populated at stage 12 (Release + client update) right before the first production deploy. Maintained continuously after.
>
> Once filled, this file moves to `docs/deployment-guide.md`. Cited from `docs/HARNESS.md § Project Doc Mapping`. Pairs with `docs/templates/release-note.md` (per-release notes) and `docs/templates/project-closure-story/02-credentials-handover.md` (handover).

## Environments

| Env | URL | Purpose | Auto-deploy from |
| --- | --- | --- | --- |
| dev | `<url>` | Active development | `<branch e.g. dev>` |
| staging | `<url>` | UAT + pre-release | `<branch e.g. main on tag>` |
| production | `<url>` | Live | `<tag pattern e.g. v*.*.*>` |

## Environment Variables

Reference: `.env.example` (committed) lists every required var with empty value. Real values live in `<secret-vault — e.g. 1Password, Doppler, Vault>`.

| Var | Purpose | Source |
| --- | --- | --- |
| `<NAME>` | `<one-line>` | `<vault path>` |

Never commit a populated `.env`. Pre-commit hook (`docs/playbooks/build-execution.md`) blocks accidental commits of `.env*` except `.env.example`.

## Build

```bash
<exact commands — e.g. pnpm install --frozen-lockfile && pnpm build>
```

Build output: `<path>`. Artifacts retained: `<duration>`.

## Deploy Steps

1. `<step — e.g. push to main → CI runs validate:quick + test:integration>`
2. `<step — e.g. tag v*.*.* → CI runs full test:release + builds image>`
3. `<step — e.g. deploy via `<provider>` (Vercel / Fly.io / Cloud Run / k8s)>`
4. `<step — run post-deploy smoke per `docs/templates/release-note.md` § 8>`

## Pre-Deploy Checklist

Mirrors `docs/templates/release-note.md` § 7:

- [ ] All tests pass on the release commit.
- [ ] DB backup taken (production only).
- [ ] Feature flags configured per release plan.
- [ ] Env vars deployed to the target environment.
- [ ] Third-party services notified if behavior change is user-visible.
- [ ] Rollback tested in staging.
- [ ] On-call available for the deploy window.

## Post-Deploy Smoke

Mirrors `docs/templates/release-note.md` § 8. Manual checks:

- [ ] Homepage loads.
- [ ] Login works.
- [ ] Core action of the release works.
- [ ] Error rate within budget (per monitoring).
- [ ] Alerts not firing.
- [ ] Payment flow (if payment is part of product).
- [ ] Background jobs ran on schedule.
- [ ] Logs show no panic.

## Rollback

```bash
<exact commands or runbook>
```

Trigger rollback when: `<criteria — e.g. error rate > X% within 10 min, or any S1 incident>`.

## Monitoring & Alerts

| Signal | Threshold | Action |
| --- | --- | --- |
| HTTP 5xx rate | `<e.g. >1% over 5 min>` | `<page on-call>` |
| P95 latency | `<budget from high-risk-story design.md § Performance Budget>` | `<alert channel>` |
| Background job failure | `<>0 in 5 min>` | `<alert channel>` |

Dashboards: `<links>`.

## Runbook

Common incidents and their first-response steps. Add entries as incidents occur.

| Symptom | First check | Likely cause | Mitigation |
| --- | --- | --- | --- |

## Cross-Reference

- `docs/HARNESS.md § Project Doc Mapping` — why this file exists.
- `docs/templates/release-note.md` — per-release notes (pre / post / rollback / client update).
- `docs/templates/project-closure-story/02-credentials-handover.md` — handover-time pointers.
- `docs/ARCHITECTURE.md § Observability Contract` — log shape contract.
