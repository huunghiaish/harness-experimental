# NNNN Stack Selection

Date: YYYY-MM-DD

## Status

Proposed | Accepted | Superseded | Rejected

## Context

Specialized decision template for the first stack-selection decision of a project. Required for high-risk lane, recommended for normal lane. Triggered by `docs/AGENTS.md § Task Loop` step 6 ("confirm the runtime stack has been recorded before writing code") and `docs/ARCHITECTURE.md § Discovery Before Shape`.

Sources read before deciding:

- `docs/discovery/*` — raw client/brainstorm inputs.
- `docs/intake/YYYY-MM-DD-spec-intake.md` — Phase-1 read+restate output.
- `docs/intake/YYYY-MM-DD-gap-analysis.md` (if existing system → tech-stack constraints).
- SOW § technical constraints (if commercial project).

## Decision

Answer each row. Leave the **Reason** column non-empty — drift later is expensive.

### Core Runtime

| Item | Choice | Reason | Alternatives considered |
| --- | --- | --- | --- |
| Language + version | `<e.g. TypeScript 5.4 on Node.js 22 LTS>` | `<one line>` | `<list>` |
| Server framework | `<e.g. NestJS 10, FastAPI 0.110, Next.js App Router 14>` | | |
| Primary database | `<e.g. PostgreSQL 16, MongoDB 7>` | | |
| Cache / queue | `<e.g. Redis 7, BullMQ, none>` | | |

### Surfaces

| Surface | Choice | Reason |
| --- | --- | --- |
| Web frontend | `<framework + state mgmt — e.g. React 18 + TanStack Query>` | |
| Mobile (if needed) | `<e.g. React Native, Flutter, native, none>` | |
| Desktop (if needed) | `<e.g. Electron, Tauri, none>` | |
| Admin / internal UI | `<reuse main or separate>` | |
| API style | `<REST / GraphQL / tRPC / gRPC>` | |

### External Providers

| Capability | Provider | Reason |
| --- | --- | --- |
| Auth | `<e.g. Better Auth, Clerk, Auth0, Supabase, custom>` | |
| Payment | `<e.g. Stripe, SePay (VN), Paddle, Polar, none>` | |
| Email transactional | `<e.g. Resend, Postmark, SES>` | |
| File storage | `<e.g. S3, R2, Supabase Storage>` | |
| Observability | `<logs / metrics / traces stack — e.g. Better Stack, Grafana Cloud, Datadog>` | |
| Error reporting | `<e.g. Sentry, none>` | |
| AI provider (if AI feature) | `<e.g. Anthropic API direct, OpenAI, OpenRouter, multi-provider>` | |

### Hosting & Operations

| Item | Choice | Reason |
| --- | --- | --- |
| Application hosting | `<e.g. Vercel, Fly.io, Cloud Run, k8s>` | |
| Database hosting | `<e.g. Neon, Supabase, RDS, self-managed>` | |
| CDN / edge | `<e.g. Cloudflare, Vercel Edge, none>` | |
| CI/CD | `<e.g. GitHub Actions, GitLab CI>` | |
| Secret management | `<e.g. 1Password, Doppler, Vault, env on host>` | |
| Region(s) | `<e.g. ap-southeast-1 Singapore for VN clients>` | |

### Tooling

| Item | Choice | Reason |
| --- | --- | --- |
| Package manager | `<e.g. pnpm 9, uv, go modules>` | |
| Linter / formatter / typecheck | `<list>` | |
| Test runners (unit / integration / e2e) | `<list — drives `validate:quick` / `test:e2e`>` | |
| Pre-commit hook framework | `<e.g. husky + lint-staged, pre-commit, none>` | |

## Alternatives Considered

For any row where the chosen option was non-obvious, list the discarded alternatives and why:

1. **`<alternative>`** — discarded because `<reason>`.

## Consequences

Positive:

- `<item>`

Tradeoffs:

- `<item — e.g. "team will need to upskill on X">`

Risks accepted:

- `<item — e.g. "single provider lock-in for payment; mitigated by abstraction layer in payment-integration playbook">`

## Follow-Up

- [ ] Update `docs/code-standards.md` from `docs/templates/code-standards.md` with the rows above.
- [ ] Ensure `validate:quick` / `test:e2e` scripts exist before stage 8 starts (per `docs/playbooks/build-execution.md`).
- [ ] If AI provider chosen, read `docs/playbooks/ai-feature-integration.md`.
- [ ] If payment provider chosen, read `docs/playbooks/payment-integration.md`.
- [ ] If UI framework chosen, ensure `docs/design-guidelines.md` from stage 5 Style Intake matches.

## Cross-Reference

- `docs/ARCHITECTURE.md § Discovery Before Shape` — authority for this decision being required.
- `docs/HARNESS.md § Project Doc Mapping` — `code-standards.md` populates after this.
- `docs/templates/code-standards.md` — downstream template.
- `docs/playbooks/build-execution.md` — downstream stage-8 playbook.
