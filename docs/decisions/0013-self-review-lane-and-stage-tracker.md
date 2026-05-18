# 0013 Self-Review Lane (Default) + STAGE.md Root State Tracker

Date: 2026-05-18

## Status

Accepted

## Context

Two pains surfaced together on 2026-05-18 while looking at the harness in use on a personal AI-generated project:

1. **Tier-based stage skipping is wrong for the human-as-customer pattern.** The harness's `tiny` lane skips stages 3.B (gap analysis), 6 (visual modeling), most of 4 (SOW). The solo-dev playbook explicitly says "internal / OSS / hobby projects skip this flow". But for AI-generated projects where the human is the only quality gate, the human NEEDS every stage's artifact to act as a comprehension/approval gate — skipping stage 6 means the human never sees a prototype before code lands; skipping stage 11 means no UAT pass. The "save time by skipping" heuristic assumes a human reviewer exists who already knows what they want — not true when the human is also the customer and the entire build is AI-generated.

2. **No way to tell what stage a repo is at.** When juggling multiple projects, returning to one after time away forces the human to dig: `git log --grep "stage-"`, check folder presence (`ls docs/visuals/`), read recent intake files. No single file answers "where am I?" in one glance. The stage boundary commit rule (decision 0012) makes the timeline parseable but not summarisable.

Both pains compound: without stage tracking AND with tier-skipping enabled, the human cannot tell which stages they meant to skip vs which they forgot.

## Decision

### Part A: `self-review` lane (default)

Add a new lane to `docs/FEATURE_INTAKE.md` named `self-review`. Make it the **default** when no lane is explicitly declared.

Self-review semantics:

- **All 13 WORKFLOW.md stages run.** No stage skips. The Per-Tier Stage Matrix's "skip" cells do not apply.
- Stage artifacts produced even when small (greenfield with no As-Is still gets a one-line gap-analysis note rather than skipping stage 3.B).
- Risk-checklist flags from FEATURE_INTAKE.md change validation **depth** per stage, not which stages run.
- Commercial artifacts (priced SOW, signed proposal) become lightweight self-SOWs: scope + deadlines + done-when, no price.
- Stages 2, 4, 11, 12, 13 substitute "self" for "client" — the human plays both roles.

Legacy `tiny | normal | high-risk` lanes remain in the document for explicit opt-out. Opt-out must be declared in `STAGE.md` Lane Notes with a reason.

### Part B: `STAGE.md` at repo root

Ship `docs/templates/STAGE.md` in the installer (`scripts/install-harness.sh` HARNESS_FILES list). On `--bootstrap`, the installer copies it to repo root and fills the Snapshot section. Each stage boundary commit thereafter updates STAGE.md as part of the same commit.

STAGE.md shape:

- **Snapshot** — Lane / Current stage / Last completed (with commit SHA) / Next gate / Blockers / Updated date.
- **History** — append-only table of completed stages with commit SHAs.
- **Pending** — table of upcoming stages with gate criteria.
- **Lane Notes** — record any opt-out from self-review and reason.

Update protocol: agents update STAGE.md directly when a stage completes. The edit lands in the same commit as the stage's artifact (per decision 0012). Drift between STAGE.md and `git log --grep "stage-"` is treated as a bug — fix by inspecting git history and reconciling.

## Alternatives Considered

1. **PROJECT_MODE flag at root** — single config line like `mode: full` that overrides tier-skip rules. Rejected: easy to forget to set; doesn't address the state-tracking pain at all.
2. **scripts/stage-status.sh derived from git** — script that scans git log + folder presence to compute current stage. Rejected as sole mechanism: requires running a script every time you want to check (vs `cat STAGE.md`); harder to read offline; loses room for human notes like "blocked because waiting on client confirmation". Kept as a future cross-check tool — see Follow-Up.
3. **STAGE.md + script verify (both)** — dual-source with the script verifying STAGE.md matches git. Rejected for v1: adds maintenance burden before we know if STAGE.md drift is actually a problem. Revisit if drift bites.
4. **Eliminate tier-skip entirely** — remove tiny/normal/high-risk from FEATURE_INTAKE.md. Rejected: breaks existing projects mid-flight; some teams do want the optimization. Self-review-as-default + legacy lanes opt-out is the additive, backward-compatible path.
5. **Don't change tier rules, just add STAGE.md** — half-measure. Rejected: the original pain was tier-skip; adding state tracking without addressing the "AI skipped my stages" pain leaves the bigger problem in place.

## Consequences

Positive:

- `cat STAGE.md` answers "where is this repo at?" in one shell command. Project re-entry friction drops sharply when juggling multiple repos.
- Self-review default means AI-generated personal projects walk every stage by default — the human sees every artifact (intake brief, gap analysis, SOW, prototype, story, UAT plan, release note, handover) and acts as the customer/reviewer gate.
- Stage-by-stage commit timeline (decision 0012) + STAGE.md History row = same information in two views, cross-checkable via git log SHA.
- Backward-compatible: existing tiny/normal/high-risk lanes still work for projects that explicitly opt out.

Tradeoffs:

- Personal projects now walk more stages by default → longer onboarding before first commit hits production. This is the explicit goal (human as customer gate), but it does add ceremony where previously there was none.
- STAGE.md becomes a fourth file to remember to update (alongside TEST_MATRIX.md, story files, decisions). Mitigated by including the reminder in AGENTS.md § Task Loop step 9.
- STAGE.md can drift from git reality if agents forget to update it. Currently caught manually; future `scripts/check-stage-drift.sh` (deferred) would automate the check.

## Follow-Up

- `scripts/install-harness.sh` HARNESS_FILES list adds `docs/templates/STAGE.md`. Installer `--bootstrap` mode copies it to repo root (separate follow-up — for now bootstrap users `cp docs/templates/STAGE.md STAGE.md` manually).
- `docs/AGENTS.md` Task Loop step 0 + step 9 reference STAGE.md.
- `docs/WORKFLOW.md` Per-Tier Matrix gets a Self-Review column.
- `docs/FEATURE_INTAKE.md` adds the self-review lane section and the depth-vs-coverage classification.
- `docs/playbooks/solo-dev-client-delivery.md` § "Skip when" softened — internal/OSS/hobby no longer skip the playbook; they use self-review.
- `docs/QUICKSTART.md` § 5 lane table marks Self-Review as default.
- `docs/decisions/0012-stage-boundary-commits.md` updated to require STAGE.md in every stage commit.
- Deferred: `scripts/check-stage-drift.sh` — lint that compares STAGE.md History rows against `git log --grep "stage-"` SHAs and flags mismatches. Wait for a second project to confirm the drift pattern actually bites.

## Cross-Reference

- `docs/FEATURE_INTAKE.md` § Lanes § Self-Review — operational definition.
- `docs/WORKFLOW.md` § Per-Tier Stage Matrix — Self-Review column.
- `docs/templates/STAGE.md` — canonical template installer ships.
- `docs/decisions/0012-stage-boundary-commits.md` — companion rule (STAGE.md edit goes in the same commit).
- `docs/decisions/0007-solo-dev-client-delivery-templates.md` — commercial wrapper this decision extends with the self-SOW substitution.
- `docs/decisions/0011-bootstrap-installer-mode.md` — bootstrap flow STAGE.md will integrate into.
