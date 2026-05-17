# Roadmap — ClaudeKit Custom Port Into Harness

**Date:** 2026-05-17 · **Status:** Proposal (awaits approval per plan) · **Branch:** main

Strategic roadmap covering all 27 artifacts (21 skills + 6 patches) from `xia-260517-1130-claudekit-custom-skill-scan.md`. Built around harness's core principles, not around ClaudeKit's delivery model.

---

## Harness Principles Guarding This Roadmap

Every item below was scored against these. Any item that violates them is REJECTED, not just deferred.

1. **Grows from friction.** No pre-built artifact ships before measured demand. Pattern/protocol can ship; concrete artifacts wait.
2. **KISS / YAGNI.** Lightweight templates over comprehensive frameworks. Tiered intake (tiny/normal/high-risk) sets ceremony level.
3. **Cross-project portable.** No project-specific paths, locale assumptions, or stack lock-in inside the harness.
4. **Operating-model coherence.** `AGENTS.md`, `HARNESS.md`, `FEATURE_INTAKE.md`, `ARCHITECTURE.md` stay read-only at the harness level. Org changes = fork, not patch.
5. **Decisions explain why, playbooks explain how, stories explain what.** No mixing.
6. **Hard gates:** auth, authorization, data, audit, external systems → automatically high-risk.

---

## Inventory — Current State Of All 27 Artifacts

### Tier S (8) — Direct fit

| # | Item | Current state | Owning plan |
|---|------|--------------|-------------|
| S1 | RRI (discovery interview) | Deferred in 0004 | **Plan C** (new) |
| S2 | Scenario taxonomy (12 dimensions) | Deferred in 0004 | **Plan C** |
| S3 | UAT + Signoff + Client-Update chain | Deferred in 0004 | **Plan C** |
| S4 | E2E Flow + Seed Data | Untracked — silent dropout | **Plan D** (new) |
| S5 | Patch markers | ✅ DONE | Plan A Phase 02 |
| S6 | Pre-Release + Production Readiness | Planned, not started | **Plan B** |
| S7 | Code Review Scoring X/10 | Untracked — silent dropout | **Plan D** |
| S8 | Handover + Project Status | Untracked — silent dropout | **Plan D** |

### Tier A (5) — Strong pattern, partial fit

| # | Item | Decision | Owning plan |
|---|------|----------|-------------|
| A1 | XRE validate mode + CR workflow | Partial port (skip IEEE 830) | **Plan E** (optional) |
| A2 | Scope confirmation feature register | Partial port (skip Excel/wireframes) | **Plan E** |
| A3 | QA video evidence + REQ coverage | Pattern port | **Plan E** |
| A4 | UX-design aggregator pattern | ✅ DONE | Plan A Phase 04 (composition pattern) |
| A5 | Tech-design aggregator pattern | ✅ DONE | Plan A Phase 04 |

### Tier B (5) — Interesting, not yet a fit

| # | Item | Decision |
|---|------|----------|
| B1 | ck:intake-file naming convention | **Backlog** (proposed) |
| B2 | ck:persona discovery process | **Backlog** (proposed) |
| B3 | ck:brand-guidelines discovery process | **Backlog** (proposed) |
| B4 | ck:hypercare | Merged into Plan B (same surface as prod-readiness) |
| B5 | ck:extract-design-system multi-image pattern | **Backlog** (proposed) |

### Cross-cutting (5) — Patterns

| # | Item | Owning plan |
|---|------|-------------|
| X1 | Patch marker pattern | ✅ Plan A Phase 02 |
| X2 | Aggregator/composition | ✅ Plan A Phase 04 |
| X3 | REQ/SC/TC traceability tokens | ✅ Plan A Phase 01 |
| X4 | Bilingual template pattern | ✅ Plan A Phase 03 |
| X5 | Idempotency + freshness metadata | ✅ Plan A Phase 04 (folded into composition) |

---

## Roadmap — Phased Sequence

Order chosen by: dependency (downstream needs upstream tokens/protocols), risk (docs-only before installer touch), value (safety nets early, ergonomics later).

```text
Plan A ✅ → Plan B → Plan C → Plan D → Plan E (optional)
conventions  lifecycle  discovery   quality    extra
+ protocol   + installer + delivery  + closure  patterns
```

### Plan A — Conventions + Protocol ✅ DONE

**Status:** Completed 2026-05-17. All grep validation checks pass.

**Scope delivered:**
- Traceability tokens (composite ID `US-NNN.REQ-MMM`) in `HARNESS.md` + `TEST_MATRIX.md` row note
- Patch extension protocol (`HARNESS:EXT` markers) in `docs/playbooks/PATCH-EXTENSION-PROTOCOL.md`
- Bilingual delivery template pattern (locale-agnostic) in `docs/playbooks/bilingual-delivery-template-pattern.md`
- Playbook composition pattern + freshness metadata in `docs/playbooks/playbook-composition-pattern.md`
- README footnote linking the two locale/composition playbooks

**Benefit realized:**
- Cross-project audit becomes possible (`grep US-014.REQ-` works).
- Teams can extend playbooks via `HARNESS:EXT` markers without forking.
- Locale + composition patterns documented; no premature artifacts shipped.

**Effort spent:** ~3-4h.

---

### Plan B — Lifecycle Gates + Installer Marker-Preserve

**Status:** Planned (decision 0004 Q3 accepted), not started.

**Scope:**
1. `docs/playbooks/production-readiness-checklist.md` — pre-ship checklist (security, backup, rollback, DNS, SSL, monitoring). Each row cites a `TC-` token where possible.
2. `docs/playbooks/hypercare-plan.md` — post-go-live support shape (incident process, escalation, rotation, retro hook).
3. `docs/templates/high-risk-story/execplan.md` — add 1 required line: "If this story moves to production, link to `production-readiness-checklist` playbook before merge."
4. `scripts/install-harness.sh` — preserve `HARNESS:EXT:START/END` blocks on `--override` and `--merge`. Add a shell-level test fixture (`scripts/test-install-marker-preserve.sh`).

**Benefit:**
- High-risk stories cannot silently ship without prod-readiness coverage (template gate).
- Hypercare playbook gives ops/support handoff a portable shape, not an ad-hoc doc per project.
- Installer protects org extensions automatically — Plan A's patch protocol becomes enforceable, not honour-system.

**Effort:** ~4-6h.
**Risk:** Normal (installer behaviour change). Adds a test fixture; rollback = revert install-harness.sh.

**Dependencies:** Plan A complete (uses tokens + patch protocol).

**Out of scope:** Code review scoring (moved to Plan D). Hypercare integration with external comms tools (org-level fork concern).

---

### Plan C — Discovery + Delivery Loop

**Status:** New. Deferred from decision 0004; promote to decision 0005 + this plan.

**Scope:**
1. `docs/playbooks/discovery-interview-playbook.md` — RRI-style 5-persona interview framework (End User, BA, QA, Developer, Operator), 3 question modes (challenge / guided / explore), question bank by persona+mode. Output: requirements list with `REQ-` tokens, decisions list with decision-doc cross-links. **Per harness: this is a PLAYBOOK (recipe), not a template (artifact). It generates story input, doesn't replace stories.**
2. `docs/playbooks/scenario-taxonomy-playbook.md` — 12-dimension edge-case generator (input validation, concurrency, state, boundary, error, performance, security, compliance, integration, data, deployment, rollback). Output: scenario list with `SC-` tokens. Reference from TEST_MATRIX rows.
3. `docs/templates/delivery-closure-story/` — story template covering: UAT journey table (citing `TC-` tokens), signoff doc (linking REQ + evidence), client-update message scaffold (locale-agnostic, no Telegram lock-in). Mark `delivery-closure-story` as a story SHAPE alongside the existing `high-risk-story/` shape.

**Benefit:**
- Closes the harness loop: discovery → story → proof → delivery, all linked by tokens.
- Discovery interview eliminates rework-from-hell (cited in xia report as Tier S's #1 leverage).
- Scenario taxonomy makes TEST_MATRIX rows defensible (each row cites the SC it proves).
- Delivery closure template gives any closure-class story (not just VN SME) a portable shape.

**Effort:** ~6-8h.
**Risk:** Tiny. Docs + templates only.

**Dependencies:** Plan A (uses REQ/SC/TC tokens). Independent of Plan B.

**Decisions needed before start:**
- Create decision `0005-discovery-and-delivery-loop.md` formalising scope.
- Question: should delivery closure be a STORY shape or a PLAYBOOK? Recommend STORY shape (mirrors high-risk-story/) because it has multiple required artifacts.

---

### Plan D — Quality + Closure Tools

**Status:** New. Recovers 3 silently-dropped Tier S items.

**Scope:**
1. `docs/playbooks/code-review-scoring.md` — X/10 rubric (correctness 3pt + security 2pt + quality 2pt + performance 1pt + maintainability 1pt + tests 1pt). Pass/fail gate at ≥7. Per harness tier: required for high-risk, recommended for normal, optional for tiny.
2. `docs/playbooks/canonical-e2e-flow-playbook.md` — phase-typed test pattern (form / workflow / readonly / mixed), each test cited by `TC-` token. Companion: `docs/playbooks/seed-data-pattern.md` — deterministic FK-valid demo data (no VN-specific master data; pattern only).
3. `docs/templates/project-closure-story/` — handover packaging story. Required artifacts: README index, decisions index, credentials handover (encrypted reference, no secrets in git), training resource index. Distinct from delivery-closure-story (which is per-release); this is project end-of-life.
4. `docs/playbooks/project-status-snapshot.md` — read-only SDLC state detector pattern. Inspects `docs/stories/` + `docs/TEST_MATRIX.md` to report "where are we now". No write side; runs by agent reading docs.

**Benefit:**
- Code review scoring makes "good enough to ship" measurable, not subjective. Audit trail per release.
- E2E flow + seed playbook gives test stories a portable test recipe — eliminates "how do we set up state for test X?" recurring friction.
- Project closure story handles end-of-project handoff (different from per-release delivery closure in Plan C).
- Project status snapshot helps context-restoration when picking up an in-flight project.

**Effort:** ~5-8h.
**Risk:** Tiny. Docs only.

**Dependencies:** Plan A (tokens), Plan C (delivery-closure-story exists so this can distinguish). Plan B not required but synergistic.

**Items considered then rejected:** Seed data with VN master data baked in (rejected — locale assumption). Project-status as executable script (rejected — harness has no runtime; agent reads docs instead).

---

### Plan E — Tier A Patterns (Optional)

**Status:** New. Only run if Plan D output reveals friction the Tier A patterns would address.

**Scope:**
1. `docs/playbooks/requirements-validation-playbook.md` — port XRE validate mode + CR workflow (intake → scout → validate → estimate → apply → changelog). Skip IEEE 830 SRS rigor; harness already keeps requirements lightweight (RRI from Plan C is the discovery instrument).
2. `docs/templates/feature-register.md` — port scope-confirmation feature register (ID | name | status | notes | open questions | exclusions). Markdown-only, no Excel/Mermaid/SVG. Pairs with Plan C delivery-closure-story.
3. `docs/playbooks/qa-evidence-playbook.md` — port video evidence + REQ coverage pattern from ck:qa. Tier classification (1a critical path / 1b happy path / 2 error states). Does NOT prescribe Playwright; team owns test infrastructure.

**Benefit:**
- Requirements validation playbook gives RRI output a verification step (gaps, ambiguity, infeasibility).
- Feature register template gives scope baseline a single-source-of-truth shape (lighter than building it ad-hoc in stories).
- QA evidence playbook standardises what "proof exists" means for test rows in TEST_MATRIX.

**Effort:** ~4-6h.
**Risk:** Tiny. Docs only.

**Why optional:** Significant overlap with Plan C (RRI overlaps with XRE validate; delivery closure overlaps with feature register concept). Only port if Plan C outputs reveal a real gap.

**Decisions needed:** None until Plan D is reviewed.

---

## Items Going To HARNESS_BACKLOG.md (Not Plans)

These are intentionally NOT in any plan above. They wait for measured friction before a decision is written.

| # | Item | Reason it waits |
|---|------|----------------|
| B1 | ck:intake-file naming convention (`{date}-{type}-{name}.{ext}`) | Harness doesn't prescribe a discovery-input folder structure. If 2+ projects end up reinventing the same file-naming scheme, promote to playbook. |
| B2 | Persona discovery process | Plan C RRI playbook likely subsumes 80% of this. Revisit after Plan C ships. |
| B3 | Brand-guidelines discovery process | Out of harness mission scope (UX-direction). Belongs in `docs/playbooks/ui-design-system-contract.md` § Style Intake which already exists. Possibly amend that playbook, not create new. |
| B5 | Multi-image analysis pattern | Specialised use case. Wait for 2nd project asking. |
| (future) | Pre-built aggregator playbooks (e.g. `full-discovery-flow.md`) | Per Plan A Phase 04 composition pattern: ship the pattern, not the aggregator. Promote only when 3+ projects ask the same composition question. |

**Action:** add as `Missing Harness Capability` entries in `docs/HARNESS_BACKLOG.md` with status `proposed`.

---

## Rejected Outright (Won't Port — Violates Harness Principles)

| Item from ck:custom | Why rejected |
|---------------------|--------------|
| Full IEEE 830 SRS extraction (ck:xre extract mode) | Too heavyweight. Harness keeps requirements story-shaped, not standards-doc-shaped. |
| Wireframe generation, Mermaid HTML output, SVG diagrams (ck:scope-package, ck:ux-design) | Client-deliverable generation, not harness mission. Team's tool choice. |
| Pre-translated locale templates (VN) | Decision 0004 Q4. Pattern shipped; locale never. |
| Pre-built aggregator playbooks | Decision 0004 Q5. Pattern shipped; aggregators wait for friction. |
| Excel/XLSX outputs | Out of harness scope (no binary deliverables). |
| Telegram-specific client-update automation | Org/team comms choice, not harness concern. Pattern documented in Plan C, channel-neutral. |
| ck:seed VN master data (3321 ward dataset) | Locale-specific. Pattern (deterministic FK-valid seed) goes in Plan D, data does not. |
| Hardcoded VN business rules (40-case UAT cap, etc.) | Domain assumption. Pattern documented without the cap. |

---

## Effort Summary

| Plan | Effort | Risk | Cumulative |
|------|--------|------|------------|
| A ✅ | ~4h | tiny | done |
| B | 4-6h | normal (installer) | 8-10h |
| C | 6-8h | tiny | 14-18h |
| D | 5-8h | tiny | 19-26h |
| E (optional) | 4-6h | tiny | 23-32h |

**Critical path:** A → B (installer is the only normal-risk item). After B, C/D/E can run in any order or in parallel for separate-file ownership.

---

## Decision Records Needed

| Decision | Plan | Purpose |
|----------|------|---------|
| 0004 ✅ | A | Adopt ClaudeKit Custom patterns (5 patterns). |
| 0005 (proposed) | C | Discovery + delivery loop (RRI playbook, scenario taxonomy, delivery closure story). |
| 0006 (proposed) | D | Quality + closure tools (code review scoring, e2e/seed pattern, project closure story, project status snapshot). |
| 0007 (proposed) | E | Tier A pattern adoption — only if Plan D review reveals gaps. |

Plan B does NOT need a new decision — it executes 0004 Q3 + installer enforcement which is implied by 0004 Q2.

---

## Acceptance Criteria For This Roadmap

User approves the roadmap if:

1. Every Tier S item is accounted for (plan / backlog / rejected). ✅
2. Every Tier A item is accounted for. ✅
3. Every Tier B item is accounted for. ✅
4. Cross-cutting patterns are accounted for. ✅
5. Each plan declares: scope, benefit, effort, risk, dependencies, decisions needed.
6. Rejected items have a rationale tied to a harness principle.

If user approves, next mechanical step is:
- Commit Plan A output (decision 0004 + plans/260517-1213/ + 3 new playbooks + HARNESS.md edits) as 1 logical change.
- Create decision 0005 + Plan C directory.
- Add backlog entries (B1, B2, B3, B5).

---

## Unresolved Questions

1. **Plan ordering preference:** strict sequential (A done → B → C → D → E) or allow parallel C+D after B? Plans C and D have no file overlap, so parallel is technically safe.

2. **Plan B priority vs Plan C:** Plan B has the only installer touch (normal risk). Plan C has higher immediate value (closes discovery→delivery loop). Run B first to ship installer safety net, OR run C first to get visible loop closure?

3. **Backlog promotion criteria:** what's the threshold for promoting a backlog item to a decision? My recommendation: 2+ projects independently asking for the same capability, OR 1 project hitting it 3+ times. Worth codifying in `HARNESS_BACKLOG.md` § Promotion Rule?

4. **Plan E gating:** should Plan E be conditional ("only if Plan D output reveals friction") or scheduled now? Conditional is more "grows from friction" but creates ambiguity about who owns the trigger.

5. **Project status snapshot playbook (Plan D #4):** is this a playbook or a small Python script? My read: playbook (agent reads docs and reports). But ck:custom shipped it as a Python skill. Confirm preference.
