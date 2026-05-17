# 0012 Stage Boundary Commits

Date: 2026-05-17

## Status

Accepted

## Context

`docs/WORKFLOW.md` defines 13 stages from Lead → Handover, each producing a named artifact (intake brief, discovery summary, gap analysis, SOW, product contract, prototype, story packets, code, TEST_MATRIX rows, release note, handover docs). `docs/playbooks/build-execution.md` § Commit Cadence already covers stage 8 (Build): 30-90 min cadence, per-story branching, token-citation hook. But stages 1-7 and 9-13 — which are doc-heavy, not code-heavy — had no explicit commit-boundary rule.

Demand evidence: 2026-05-17 same-day friction on the first real client project. After `--bootstrap` (which now creates the harness baseline commit per decision 0011 addendum), phase 1 (Spec Intake / stage 2) wrote `docs/intake/…` but the user noticed that without a commit at each stage boundary, the next stage's diff would absorb everything from previous stages too. Reviewing `git log` after 4-5 stages without boundary commits → impossible to bisect when an upstream stage introduced a bad assumption.

The bootstrap addendum solved the harness ↔ phase-1 boundary. This decision generalises the same principle to every stage transition.

## Decision

**Rule:** At the end of every WORKFLOW.md stage that produces a repo artifact, commit all stage outputs in **one bundled commit** before starting the next stage. Stage 8 (Build) keeps its own per-story cadence per `build-execution.md`; the rule applies to stage 8's closure commit (final TEST_MATRIX update + story status flip), not to interior build commits.

**Commit message format:** conventional commits with stage tag in the subject.

```text
<type>(<scope>): stage-NN <one-line summary>
```

Per-stage suggested form (non-exhaustive — adapt scope per project):

| Stage | Suggested commit |
|---|---|
| 2 Intake brief | `docs(intake): stage-2 intake brief` |
| 3.A Discovery interview | `docs(intake): stage-3a discovery summary` |
| 3.B Gap analysis | `docs(intake): stage-3b gap analysis + MoSCoW` |
| 4 Proposal & SOW | `docs(sow): stage-4 SOW vN.N` (SOW PDF lives outside repo — commit the SOW source if any) |
| 5 Spec + Design intake | `docs(product): stage-5 product contract + stack decision + design guidelines` |
| 6 Visual & Behavioral Modeling | `docs(visuals): stage-6 prototype + diagrams + RPM + status flows` |
| 7 Story slicing | `docs(stories): stage-7 epic EXX + US-NNN..US-MMM` |
| 8 Build | per `build-execution.md` § Commit Cadence; final commit: `chore(stage-8): close story US-NNN — TEST_MATRIX updated` |
| 9 Code review | `docs(review): stage-9 review report — US-NNN` (or PR comments only, no commit) |
| 10 QA + scenarios | `docs(test): stage-10 TEST_MATRIX rows — US-NNN..` |
| 11 UAT + signoff | `docs(stories): stage-11 UAT signoff — US-NNN..` |
| 12 Release + client update | `docs(release): stage-12 release note vX.Y.Z + smoke checklist` |
| 13 Handover + maintenance | `docs(handover): stage-13 handover docs + maintenance proposal` |

**Skipped stages:** if a stage skips per `docs/FEATURE_INTAKE.md` lane (e.g. tiny lane skips stages 3.B, 6), no commit fires for that stage — there's no artifact to commit.

**Token citation:** stages 1-5 generally pre-date story tokens (`US-NNN.REQ-MMM`) — no token required in those commits. Stages 6+ should cite tokens when applicable (per `build-execution.md`). The token-citation `commit-msg` hook is installed at stage 8 startup, so earlier stages naturally bypass it.

## Alternatives Considered

1. **No rule — let developers commit at any cadence** — rejected: same as no rule before this decision, which produced the 2026-05-17 friction. Without an explicit boundary marker, audit trails and bisect-ability degrade.
2. **One commit per artifact (multiple commits per stage)** — rejected for stages 1-7, 9-13: doc stages produce 1-5 related artifacts; bundling at the stage boundary keeps the history a clean stage-by-stage timeline. Per-artifact commits add noise. Stage 8 already does per-story commits because code changes need finer granularity for review.
3. **Squash all setup stages into one commit** — rejected: collapses the audit trail. Each stage represents a distinct decision point (intake → discovery → gap → SOW → spec → visuals → stories); collapsing them removes the ability to bisect across decision boundaries.
4. **Decision lives in `build-execution.md`** — rejected: build-execution scoping is stage 8. This rule is cross-stage; it belongs as a decision + a section in `WORKFLOW.md § Always-On Layer`.

## Consequences

Positive:

- `git log --oneline` becomes a stage-by-stage project timeline.
- `git bisect` can isolate which stage introduced a bad assumption (e.g. wrong stack decision surfacing as a build-stage friction → bisect lands on the stage-5 commit).
- Stage diffs stay reviewable — stage-2 intake-brief commit ≠ stage-5 product-contract commit.
- Compatible with existing rules: bootstrap auto-commit (decision 0011 addendum), per-story commits in stage 8 (build-execution.md), token-citation hook (build-execution.md).

Tradeoffs:

- Stage 5 + stage 6 commits can be large (5-10+ files). Acceptable — these are infrequent, deliberate boundary commits.
- Solo developers running through 3-4 stages in one session need to remember to commit at each boundary. Mitigation: the QUICKSTART + Task Loop already prompt "did stage N change?"; adding "commit at stage boundary" is a small extension.
- Stage 9 (Code review) and stage 11 (UAT signoff) may not always produce repo commits (PR comments / external signoff). Rule is "if there's a repo artifact, commit it" — silent when nothing changed.

## Follow-Up

- `docs/WORKFLOW.md` § Always-On Layer gets a new subsection `Stage Boundary Commits` linking back to this decision.
- `docs/QUICKSTART.md` § 0 (Verify install) gets a one-line cross-reference so first-time users see the rule before stage 1 starts.
- Future enhancement (deferred): a `scripts/check-stage-commits.sh` lint that scans recent commits and flags missing stage tags. Not built now — wait for a second project to confirm the rule sticks before automating.

## Cross-Reference

- `docs/WORKFLOW.md` § Stage-By-Stage Map — per-stage artifact list this rule operates on.
- `docs/WORKFLOW.md` § Always-On Layer — where the rule lives operationally.
- `docs/decisions/0011-bootstrap-installer-mode.md` § Addendum — bootstrap baseline commit, the case-zero of this rule.
- `docs/playbooks/build-execution.md` § Commit Cadence — stage 8 per-story cadence, complements this rule.
- `docs/playbooks/build-execution.md` § Token-Citation Hook — applies to stages 8+; stages 1-5 commits pre-date the hook install.
