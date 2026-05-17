# Pre-Flight Workflow Audit — Harness v0

**Date:** 2026-05-17 17:28
**Author:** Claude (Opus 4.7)
**Scope:** review harness state before user starts first real paid project.
**Method:** read 13-stage WORKFLOW, AGENTS, HARNESS, FEATURE_INTAKE, ARCHITECTURE, all 20 playbooks index entries + key bodies (solo-dev-client-delivery, README, templates), all 10 decisions index, HARNESS_BACKLOG, installer heredoc drift check.

## Verdict

Harness is **structurally sound** and ready for a real project. 13-stage flow, token chain (GAP→REQ→SC→TC), per-tier matrix, decision audit map, bilingual fork pattern, and Independence Principle all check out. Installer heredoc has zero drift (verified by `comm` vs `git ls-files`).

But every playbook is still `Lifecycle: experimental` — first real project IS the verification cycle. That's expected, just be ready to update `First use` / `Verified by` lines as you go.

The actual punch list (ordered by when it bites):

---

## Critical — fix before opening real project

### C1. SPEC.md vs SOW ambiguity (stage 5 entry)

- `solo-dev-client-delivery.md` § stage 5 says "derive from the signed spec".
- `FEATURE_INTAKE.md` § Spec Approval Gate assumes a `SPEC.md` exists at project root.
- README greenfield bootstrap puts the user's spec at `./SPEC.md` directly — bypassing stage 1-4 (lead → intake brief → discovery → SOW).
- For paid client work the SOW IS the contract, but `proposal-sow.md` is one-page commercial — not the spec.
- **Question to resolve:** is the SOW the spec input for stage 5, or does stage 5 expect a separate `SPEC.md` derived from SOW + discovery + gap-analysis? If the latter, who writes it and when? **Recommend:** add a 3-line clarification in `solo-dev-client-delivery.md` § stage 5 + WORKFLOW.md § stage 5 stating exactly what document feeds `spec-intake.md`.

### C2. No stack-selection decision template

- `ARCHITECTURE.md § Discovery Before Shape` mandates a stack decision before code, and `AGENTS.md § Task Loop` step 6 enforces it.
- `decision.md` template is generic — agent has to invent the structure for stack selection (runtime / framework / DB / hosting / auth provider / payment provider / observability stack).
- **Fix:** ship `docs/templates/decisions/stack-selection.md` with the 8-10 questions ARCHITECTURE wants answered. Saves 30+ min of re-deriving the shape on first use.

### C3. Bootstrap-mode flag (HARNESS_BACKLOG item already proposed)

- Greenfield path today = 4 manual commands (`mkdir`, `curl install`, `cp SPEC.md`, `git init && commit`). User will hit this in the next 30 minutes when they start the real project.
- Backlog already has this with status `proposed`. **Promote now** — single-project sustained-pain trigger per decision 0005 § 5 will fire on first use anyway.
- If too risky to add today, document the manual path more clearly with a single copy-paste shell snippet in README.

### C4. No `validate:quick` / CI scaffold

- `HARNESS.md § Future Validation Ladder` explicitly defers validation scripts.
- Stage 8 (Build) and stage 9 (Code Review) reference scoring + commit hygiene but the rubric assumes lint/typecheck/test commands exist.
- **Fix:** when first stack-selection decision lands, the SAME story should produce `package.json` (or equivalent) + a minimal `validate:quick` script + `.github/workflows/ci.yml` skeleton. Without this, every stage-8 task re-invents CI under timeline pressure.
- This is not a harness file — it's a "stage 5 derivative" expectation. Worth a short playbook `docs/playbooks/validation-ladder-bootstrap.md` describing what scripts must exist before stage 8 starts.

---

## Strongly recommended — before stage 5 (Spec + Design intake)

### S1. Build-stage playbook is missing

Stage 8 (Build) has no dedicated playbook — only `story.md § Implementation Guardrails`. Missing:

- Branching strategy (trunk vs feature branches; solo dev = trunk usually fine but say so).
- Commit cadence + token citation enforcement (you can pre-commit-hook this; the rule is documented, the hook isn't).
- Pre-commit hook recipe (lint/format/typecheck; the `validate:quick` ladder lives here).
- Dev-environment-setup recipe (`.env.example`, secret-loading pattern).

**Fix:** one short playbook `docs/playbooks/build-execution.md` referenced from stage 8 in both WORKFLOW.md and solo-dev-client-delivery.md.

### S2. User's global CLAUDE.md expects docs harness doesn't ship

`~/.claude/CLAUDE.md § Documentation Management` lists required project docs:

- `docs/project-overview-pdr.md`
- `docs/code-standards.md`
- `docs/codebase-summary.md`
- `docs/design-guidelines.md` (harness produces this at stage 5 ✓)
- `docs/deployment-guide.md`
- `docs/system-architecture.md`
- `docs/project-roadmap.md` + `docs/project-changelog.md`

Harness ships **none** of these as stubs. When the user's primary workflow tries to update them (per their own rules), agents will get confused — does the harness override the global rule, or vice versa?

**Fix one of two ways:**

- (a) Ship empty stubs / `<placeholder>` versions of the 7 missing docs in `docs/templates/project-docs/` and have stage 5 spec-intake populate them, OR
- (b) Add a § Project-Doc Mapping section in HARNESS.md saying which harness docs satisfy which global-rule docs (e.g. `docs/HARNESS.md` + `docs/product/*` = the "project-overview-pdr" equivalent; `docs/ARCHITECTURE.md` + decisions/* = "system-architecture").

(b) is cheaper. Pick before stage 5 so agents don't write both files in parallel.

### S3. Observability + secrets policy under-specified

- `ARCHITECTURE.md § Observability Contract` defines a JSON log shape but no template log line, error envelope, or audit-log row shape.
- Secrets policy only appears at handover stage 13 (`02-credentials-handover.md`). No `docs/playbooks/dev-secrets-and-env.md` for **during** development.

**Fix:** ship two small playbooks. Even half a page each is enough.

### S4. Performance budget template

Code-review rubric has performance=1 dimension, but no "budget" artifact. For high-risk lane `design.md` is the home, but the shape isn't given.

**Fix:** add a § Performance Budget table stub to `high-risk-story/design.md` template (P95 latency, LCP/INP/CLS, payload, query count). 4 lines of YAML or markdown.

### S5. Privacy / PII inventory

For VN clients (and if EU comes), data-protection is implicit (`Audit/security` risk flag in FEATURE_INTAKE). No PII inventory artifact at stage 5.

**Fix:** add a § Data Inventory line to `spec-intake.md` template asking "what personal data does this product collect, and what's the lawful basis?". Tiny scope, big leverage for any stateful product.

### S6. WORKFLOW.md as the navigation map is great — but it's long (354 lines)

For a first-project user, `docs/QUICKSTART.md` covering "you've installed, here's the first 3 hours" (run install → place spec → run intake → human approval → first decision → first story) would short-circuit the workflow.md read.

**Fix:** 30-line QUICKSTART.md that points to WORKFLOW.md for full detail.

---

## Nice-to-have — surfaces after first project starts

### N1. Promote experimental playbooks → verified
Every playbook is currently `Lifecycle: experimental`. After first real-project pass, run the promotion check per HARNESS.md § Playbook Lifecycle for every playbook actually exercised. Update `First use:` and `Verified by:` fields.

### N2. Dynamic file discovery for installer (HARNESS_BACKLOG B1-equivalent)
Heredoc is currently clean. But same gap will recur. The proposed tarball approach is the right fix; defer until next playbook lands without being shipped.

### N3. Session-retrospective example
Playbook exists, but no worked example. After first session, save the retro and reference it in the playbook body as "see worked example: …".

### N4. Stage-8 commit-message linter recipe
"Every commit cites at least one US-NNN.REQ-MMM token" is enforced socially. A `commit-msg` git hook checking for `US-\d+\.(REQ|SC|TC)-\d+` regex would be a 10-line script.

### N5. US-001-install-harness.md as starter content
The installer copies `docs/stories/US-001-install-harness.md` into every project. Useful as an example, but on a real client project this story is irrelevant noise. **Suggest:** move to `docs/stories/examples/` so it's clearly tagged as starter material, not active work.

---

## Redundant — defer or reject

### R1. HARNESS_BACKLOG B2 (persona playbook)
Discovery-interview already covers it via 5 personas × 3 modes. The backlog entry even says "defer at minimum until Plan C ships". **Recommend:** mark `rejected` (or merge note into discovery-interview-playbook).

### R2. HARNESS_BACKLOG B3 (brand-direction non-UI)
Demand evidence = none. **Recommend:** mark `rejected` until two distinct projects ask.

### R3. HARNESS_BACKLOG B5 (multi-image analysis pattern)
Speculative. **Recommend:** keep `proposed` but don't act; revisit if a real project surfaces it.

### R4. HARNESS_BACKLOG B6 (move /ck:* refs into Tooling Hints appendix)
Doc reorg only, no logic change. Worth doing eventually for Independence Principle hygiene, but not blocking. **Recommend:** keep `proposed`; resolve after first project if it didn't bite.

---

## Decision-map sanity check

| Decision | Status check |
|---|---|
| 0001-0010 | All linked from WORKFLOW.md § Decision Audit Map ✓ |
| 0007 | Stage 4 + 11 + 12 + 13 all cite it as authorising decision ✓ |
| 0008 | Stage 6 ✓ |
| 0010 | Stage 3.B ✓ |

No gaps. No orphan decisions.

---

## Installer drift check

Diffed heredoc against `git ls-files docs/` — only `docs/discovery/2026-05-17-solo-dev-vibecode-workflow-vn.md` is in repo but not installed (correct: project-specific discovery content shouldn't ship to new projects). Heredoc is in sync.

---

## Open Questions

1. SPEC.md vs SOW — which is the input to stage 5 spec-intake? (Critical C1.)
2. Should the harness ship stubs of the 7 global-CLAUDE.md-expected docs, or should HARNESS.md add a mapping section? (Strongly recommended S2.)
3. Is the user's first real project tiny / normal / high-risk lane? Affects which stages will fire and which playbooks need verification first.
4. Locale: is the first project VN-client-facing? Drives whether locale-vi templates get exercised on this run.
