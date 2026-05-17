# ClaudeKit Custom Skill Scan — Harness Mission Fit

**Scan Date:** 2026-05-17 · **Source:** `/home/nghia/claudekit-custom/` (21 skills + 6 patches) · **Target:** `/home/nghia/harness-experimental/` (meta/process framework)

---

## Tier S — Direct Fit (Port or Adapt)

### 1. **RRI (Reverse Requirements Interview)** ⭐⭐⭐
- **What:** 5-persona interview system (End User, BA, QA, Developer, Operator) → generates REQ-IDs + Architecture Summary + Decisions Log (40–60 questions per session)
- **Why it fits harness:** Core intake validation model. Harness preaches "discovery-before-shape"; RRI IS discovery validation. Provides structured interview cadence + persona-based challenge/guided/explore question taxonomy.
- **Suggested form:** `/docs/playbooks/discovery-interview-playbook.md` — portable RRI playbook for cross-project teams. Include persona framework + question bank by mode.
- **High value:** Prevents rework-from-hell via early requirements clarification.

### 2. **Scenario Edge-Case Generator** (ck:scenario)
- **What:** 12-dimension edge case exploration (input validation, concurrency, state, boundary, error, performance, security, compliance, integration, data, deployment, rollback).
- **Why it fits harness:** Harness TEST_MATRIX.md bridges behavior→proof. Scenarios ARE the behavior inventory. 12 dimensions = systematic proof matrix before QA.
- **Suggested form:** Port `/docs/templates/scenario-template.md` modeled on ck:scenario's 12-dimension taxonomy. Add to AGENTS.md playbooks-check as required story shape validation.
- **Output:** Each scenario gets SC-XXX identifier (traceability token).

### 3. **VN-Aware UAT + Signoff + Client Update Chain** (ck:uat, ck:signoff, ck:client-update)
- **What:** UAT xlsx (journey-based, business labels, 40-case cap) → signoff doc (VN, dari QA video evidence) → auto Telegram update post-ship.
- **Why it fits harness:** Harness explicitly values "delivery rigor + traceability + client handoff". This trio closes the loop: testable acceptance → signed proof → transparent updates. Bilingual delivery is pattern, not gimmick.
- **Suggested form:** `/docs/templates/delivery-closure-story/` — add UAT/Signoff sections as required story deliverables. Telegram integration as optional hook in `/AGENTS.md` (post-ship action).
- **Note:** Patterns are portable even without VN—reshape for your comms channel (Slack, email).

### 4. **E2E Flow + Demo Data Generator** (ck:e2e-flow, ck:seed)
- **What:** Per-phase canonical CRUD/workflow test cases (SC-C-NN-MM numbering) + realistic, FK-valid, deterministic demo data (70 rows per entity, seed=42).
- **Why it fits harness:** Harness emphasizes "portable recipes". E2E flows ARE the canonical test recipe. Seed data = repeatable baseline. Phase-scoped generation (not project-wide) matches harness phase storytelling model.
- **Suggested form:** Add `/docs/playbooks/canonical-e2e-flow-playbook.md` + `/docs/templates/demo-data-template.md`. Reference ck:e2e-flow's phase-type classifier (form/workflow/readonly/mixed).
- **Deliverable:** `scenarios-phase-NN.md` + `demo-data-phase-NN.{ext}` (auto-detected stack format).

### 5. **Patch System (Append-Block Markers)** 
- **What:** 6 patches applied to ClaudeKit core skills via `<!-- CK-CUSTOM:START {marker} --> ... <!-- CK-CUSTOM:END {marker} -->` marker pattern (idempotent, searchable, removable).
- **Why it fits harness:** Harness NEEDS non-destructive, cross-project customization. Patches ARE that. Harness can fork core playbooks + apply local patches (e.g., org-specific gating, VN workflows, security policies).
- **Suggested form:** Steal the marker pattern for `/docs/playbooks/` — allow teams to patch playbooks with org extensions. Document override protocol in `/AGENTS.md` (discovery phase already mentions playbooks-check).
- **Benefit:** Centralize portable recipes, decentralize org-specific shaping.

### 6. **Pre-Release & Production Readiness Gates** (patches: ck-ship-pre-release-checklist, ck-prod-readiness)
- **What:** Pre-ship security/perf/infra/functional checklist (5 categories, 🔴 block on critical) + post-ship auto-actions (deployment log, client update). Prod readiness skill covers backup/rollback/DNS/SSL/monitoring checklists.
- **Why it fits harness:** Harness values "delivery rigor". Pre-release gate = validation checkpoint. Prod readiness = explicit infrastructure handoff recipe. Both prevent surprises.
- **Suggested form:** Add `/docs/templates/pre-release-checklist-template.md` + `/docs/playbooks/production-readiness-playbook.md`. Reference in `/AGENTS.md` as mandatory pre-ship validation step.
- **Note:** Customize security matrix + perf thresholds per org.

### 7. **Code Review Scoring Gate** (patch: code-review-scoring)
- **What:** X/10 scoring (correctness 3pt + security 2pt + quality 2pt + performance/maintainability/tests 1pt each) → gate: X ≥ 7 passes to QA.
- **Why it fits harness:** Harness emphasizes "validation before next step". Scoring = measurable quality gate (not subjective). Enables audit trail.
- **Suggested form:** `/docs/templates/code-review-scoring-template.md` — add to AGENTS.md playbooks-check. Include rubric + gate rule.
- **Benefit:** Objective signoff criterion; easy to track/escalate.

### 8. **Handover Package & Project Status Skills** (ck:handover, ck:project-status)
- **What:** Handover: auto-generate delivery/ package (README, docs, videos, credentials, training, closure summary). Project-status: read-only SDLC detector → current phase + progress % + next recommended command.
- **Why it fits harness:** Handover = portable closure template (README + training + credentials packaging). Project-status = "where are we?" readiness check. Both reduce context switching friction.
- **Suggested form:** `/docs/templates/project-closure-story/` for handover template. Port project-status logic → `/AGENTS.md` as intake validation (scan project → recommend next playbook).
- **Benefit:** Standardized closure + context restoration.

---

## Tier A — Strong Pattern, Partial Fit

### 9. **XRE (Requirements Engineering: Extract/Validate/Resolve/Change-Request)** 
- **What:** Four-mode SRS tool: (1) EXTRACT IEEE 830 from raw data; (2) VALIDATE for gaps/ambiguity/edge cases/infeasibility via walkthrough; (3) RESOLVE-PATCH via AskUserQuestion; (4) CHANGE-REQUEST with impact analysis + phase-aware apply.
- **Why partial:** XRE is comprehensive but assumes formal SRS (IEEE 830 module structure). Harness philosophy is lighter-weight ("discovery-before-shape"). RRI is more discovery-first.
- **What to port:** VALIDATE mode + edge-case taxonomy (gap/ambiguity/inconsistency/infeasibility/missing NFRs). CR workflow pattern (intake→scout→validate→estimate→apply→changelog).
- **Suggested form:** `/docs/playbooks/change-request-playbook.md` — skip SRS rigor, focus on CR impact analysis + traceability token mapping.
- **Drop:** Formal IEEE 830 extraction (harness avoids heavyweight doc templates).

### 10. **Scope Confirmation & Scope Package** (ck:scope-confirmation, ck:scope-package)
- **What:** Excel feature-register + markdown companion + Mermaid diagrams (HTML) + SVG publication-quality diagrams. Scope-package also generates interactive wireframes (7 archetypes: form/list-detail/dashboard/kanban/chat/bento/timeline).
- **Why partial:** Excellent for CLIENT deliverables (scope baseline, approval matrix). Harness is PROCESS framework, not deliverable generator.
- **What to port:** Feature-register structure (table: ID | name | status | notes | questions | exclusions). Scope confirmation PROCESS (before plan, gate before dev).
- **Suggested form:** `/docs/templates/scope-baseline-story/` — lightweight markdown version (no Excel/diagrams); reference ck:scope-confirmation for client-facing enhancement.
- **Drop:** Wireframe generation (belongs in UX playbook, not harness).

### 11. **QA Skill (Real Browser Testing + Video Evidence)** (ck:qa)
- **What:** Open real browser, record video evidence, verify requirement coverage, enforce depth (3 modes: quick/standard/full). Outputs video recordings + QA report with test-to-REQ-ID traceability.
- **Why partial:** Testing execution is NOT harness mission (harness excludes app code + CI). BUT the VIDEO EVIDENCE + REQUIREMENT COVERAGE model IS valuable. Test naming (Tier 1a/1b/Tier 2) + validation depth framework.
- **What to port:** Test coverage taxonomy (Tier 1a: critical path, Tier 1b: happy path, Tier 2: error states). Required evidence types (video + requirement link).
- **Suggested form:** `/docs/templates/qa-story/` — testing delivery template. Reference ck:qa depth framework + video evidence requirement.
- **Drop:** Actual Playwright execution; harness delegates to team's test infrastructure.

### 12. **Design System & UX Design Aggregators** (ck:design-system, ck:ux-design, ck:extract-design-system)
- **What:** Design-system: HSL token expansion (3–5 colors → 50+ semantic tokens) + globals.css + tailwind.config.ts + design-system.md + preview HTML. UX-design aggregator coordinates persona → brand → design-system → wireframes.
- **Why partial:** Strong engineering patterns (composable aggregators, deterministic token expansion, idempotency checks, theme support). UX itself is NOT harness scope.
- **What to port:** Aggregator composition pattern (step-by-step skill calls in sequence, output chaining). Idempotency check (`check_freshness.py`, skip if <7d). Regenerate flag pattern.
- **Suggested form:** Doc pattern in `/docs/playbooks/` — describe "aggregator composition" workflow (when to sequence, when to parallelize). Reuse this for other playbooks.
- **Drop:** Token generation + design artifacts (upstream of harness).

### 13. **Tech Design Aggregator** (ck:tech-design)
- **What:** Aggregates brainstorm + databases + backend + security + devops into single tech-design artifact. Outputs architecture.md + DB schema + API contract + security model + 5+ SVG diagrams via ck:tech-graph.
- **Why partial:** Similar to ux-design aggregator pattern (strong composition, output chaining, diagram generation). Actual tech decisions are outside harness scope.
- **What to port:** Aggregator orchestration (parallel research agents, output coordination, diagram naming convention).
- **Suggested form:** Reference in `/docs/playbooks/` as pattern example — "how aggregators coordinate sub-skills".
- **Drop:** Tech implementation outputs (SOP for teams, not harness).

---

## Tier B — Interesting Pattern, Not Yet Fit

| Skill | Reason | Note |
|-------|--------|------|
| **ck:intake-file** | File routing/naming convention is useful, but harness doesn't prescribe discovery-input folder structure. | Port: standard file naming convention for discovery artifacts (e.g., `{date}-{type}-{name}.{ext}`). |
| **ck:persona** | User research output, not process. | Port: persona discovery PROCESS (stakeholder interview framework). Deliver: lightweight persona summary, not full delivery doc. |
| **ck:brand-guidelines** | Brand definition tool (UX scope, not harness). | Port: brand DISCOVERY process (questions to ask stakeholder). Deliver: lightweight brand-direction summary. |
| **ck:hypercare** | Post-go-live support planning. Valuable but post-harness closure. | Port: support plan CHECKLIST. Optional hook in `/AGENTS.md` (after-closure action). |
| **ck:extract-design-system** | Reverse-engineer design tokens from screenshot. Specialized UX task. | Port: multi-image analysis PATTERN (use for any multi-artifact extraction). |

---

## Cross-Cutting Observations

### 1. Patch Marker Pattern — Steal This
```markdown
<!-- CK-CUSTOM:START {marker} -->
[append content]
<!-- CK-CUSTOM:END {marker} -->
```
**Why excellent:** Idempotent, searchable (grep), removable (both markers), version-safe (marker persists across updates). Harness can use for playbook extensions + org-specific gating rules.

### 2. Aggregate vs Underlying Skill Composition
ClaudeKit Custom deliberately layers: `ck:ux-design` (aggregate) wraps `ck:persona` + `ck:brand-guidelines` + `ck:design-system` + frontend skills. Same for `ck:tech-design`, `ck:scope-package`, `ck:prod-readiness`.

**Why valuable for harness:** Aggregators reduce user cognitive load ("run /ck:ux-design" vs remembering 5 steps). Harness can apply same pattern to playbooks: `/docs/playbooks/full-ux-playbook.md` (orchestrates 5 steps) vs individual playbooks.

### 3. REQ-ID + SC-ID Traceability Tokens
- `REQ-001` (from RRI) → maps to phase requirements + acceptance criteria
- `SC-XXX` (from scenario) → edge case coverage
- `SC-C-NN-MM` (from e2e-flow) → canonical test case

**Why steal:** Harness lacks explicit traceability token system. These enable audit trail + cross-cutting search. Recommend: adopt token format in `/docs/HARNESS.md` (REQ / SC / TC prefix convention).

### 4. Bilingual (VN English) Delivery Templates
UAT/Signoff/Client-Update are **inherently bilingual** — titles in VN, instructions/automation in English. This pattern is reusable for ANY multi-locale delivery.

### 5. "Idempotency + Freshness Metadata" Pattern
`ck:design-system` checks `design-tokens/.meta.json` (age < 7 days?) before regenerating. Pattern: skip expensive rerun if output fresh, allow `--regenerate` override.

**Harness value:** Playbook execution logs could use same pattern (check `.playbook-run` metadata before re-executing high-cost playbooks).

---

## Top 3 High-Leverage Borrows (Concrete Actions)

### Action 1: Add RRI + Scenario Playbook Template
**File:** `/home/nghia/harness-experimental/docs/templates/discovery-interview-playbook.md`

**Content:**
- RRI persona framework (5 personas, 3 question modes: challenge/guided/explore)
- Scenario 12-dimension taxonomy (input, concurrency, state, boundary, error, perf, security, compliance, integration, data, deploy, rollback)
- Question bank by persona + mode
- Output tokens: REQ-XXX + SC-XXX

**Effort:** 2–3h (adapt from ck:rri + ck:scenario SKILL.md headers + reference docs)

### Action 2: Adopt Patch Marker Pattern in `/docs/playbooks/`
**File:** `/home/nghia/harness-experimental/docs/playbooks/.PATCH-EXTENSION-PROTOCOL.md`

**Content:**
- Marker syntax: `<!-- HARNESS:START {slug} -->` + `<!-- HARNESS:END {slug} -->`
- Teams can fork playbooks + patch local extensions (e.g., "add VN approval step", "add security gate")
- Example: how to patch `/docs/playbooks/delivery-closure-playbook.md` with org-specific Slack notification

**Effort:** 1–2h (document + 1 example patch)

### Action 3: UAT/Signoff/Client-Update Delivery Story Template
**File:** `/home/nghia/harness-experimental/docs/templates/delivery-closure-story/`

**Content:**
- `01-uat-template.md` — journey-based test case table (business labels, 40-case cap)
- `02-signoff-template.md` — acceptance doc (from REQ + QA evidence)
- `03-client-update-template.md` — Telegram message scaffold (auto-trigger after ship)
- `config-example.md` — how to wire Telegram token (no secrets in git)

**Benefit:** Teams adopt closure rigor without re-inventing. Bilingual pattern transfers to other locales.

**Effort:** 3–4h (adapt from ck-uat + ck-signoff + ck-client-update SKILLs + patches)

---

## Unresolved Questions

1. **Should harness adopt REQ/SC token format officially?** RRI generates REQ-001, scenario generates SC-XXX, e2e-flow generates SC-C-01-01. Standardize across harness or stay token-agnostic?

2. **Does harness want bilingual template support built-in (VN/EN)?** Or is it a team-level fork (each region creates own `/docs/templates/`)?

3. **Should playbooks support patch extensions** (allow teams to inject org rules via marker blocks)? Or keep playbooks read-only + forks separate?

4. **Hypercare + production-readiness playbooks:** Where do they sit in harness task loop? Post-closure but still AGENTS.md scope? Or purely optional (team can invoke if relevant)?

5. **Design-system + UX aggregator patterns:** Harness currently excludes app code/UX. Should these be ported as **patterns** (e.g., "how to compose multi-step playbooks") separate from actual design artifacts?

---

**Scan Complete.** Delivered: 21 skills (10 Tier S/A fit, 11 Tier B pattern); 6 patches (5 Tier S/A patterns, 1 reference); installation/management model (setup.sh, `.ck-custom` metadata). Recommended: prioritize Actions 1–3 for Q3 2026 harness roadmap.
