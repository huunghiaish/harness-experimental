# 0005 Roadmap Execution Direction

Date: 2026-05-17

## Status

Accepted

## Context

Decision `0004-adopt-claudekit-custom-patterns.md` accepted five patterns from ClaudeKit Custom but deferred concrete artifact work to "future decisions when prioritized". The accompanying roadmap report `plans/reports/roadmap-260517-1234-claudekit-custom-port-roadmap.md` proposed five plans (A done; B, C, D, E remaining) and surfaced five open questions about execution order, priority, gating, and shape.

This decision answers all five and codifies the execution direction so future agents can pick up the work without re-deriving the strategy.

## Decision

1. **Sequential plan ordering** (not parallel). Plans run A → C → B → D → E. Each plan's output validates the previous plan's design before the next begins. Single-user context (no team coordination upside to parallelism); docs-heavy work benefits from focused iteration.

2. **Plan C before Plan B.** Plan C closes a functional gap in the harness's promised loop (discovery → story → proof → delivery). Plan B is preemptive safety for a state (project shipping through installer override; high-risk story moving to production) that has not occurred. "Grows from friction" favours filling existing functional gaps over pre-building safety nets. Until Plan B ships, installer marker preservation is documented honour-system in `PATCH-EXTENSION-PROTOCOL.md`.

3. **Plan B triggers** — execute Plan B when either fires:
   - First project ships a release through `install-harness.sh --override` or `--merge` with `HARNESS:EXT` blocks present.
   - First high-risk story moves toward production (deploy story exists).

4. **Plan E is conditional.** Execute Plan E when any of these triggers fires:
   - Plan C or Plan D output reveals 2+ capability gaps that Tier A items would address.
   - A project explicitly asks for XRE-style requirements validation.
   - 6 months pass after C and D ship with no surfaced friction — revisit to drop or execute.

5. **Promotion rule for `docs/HARNESS_BACKLOG.md`.** Codify in the backlog file. A proposed item promotes to a decision (and optionally a plan) when EITHER:
   - 2 distinct projects independently ask for the same capability (cross-project signal), OR
   - 1 project hits the gap 3+ times (sustained-pain signal).
   Each backlog entry carries a `Demand evidence` field to audit threshold satisfaction.

6. **Project status snapshot is a playbook, not a script.** Harness has no runtime apart from the bootstrap installer. Agents read `docs/stories/`, `docs/TEST_MATRIX.md`, and `docs/decisions/` to report current state. If agent-read speed becomes a measured bottleneck, promote to script via the standard backlog → decision flow.

## Alternatives Considered

1. **Strict A → B → C → D → E order** (per original roadmap recommendation). Rejected — privileges safety over functional completion when no project is in the risk window yet. Violates "grows from friction".
2. **Parallel C + D after Plan A.** Rejected — single user, no coordination upside, breaks the feedback loop where each plan validates the prior one.
3. **Pre-create full phase files for all four remaining plans (B, C, D, E).** Rejected — pre-building phases for plans that may shift after C ships is itself a "grows from friction" violation. Plans B/D/E ship plan.md overview only; phase files written when execution begins.
4. **Backlog promotion by "agent judgment".** Rejected — invites scope creep. Quantitative threshold (2 projects OR 3 hits) is auditable.
5. **Ship project-status as a Python script now.** Rejected — speculative scaffolding before the bottleneck exists.

## Consequences

Positive:

- Plan order is unambiguous: anyone picking up the work after this decision knows what to do next without re-arguing priorities.
- Plan B and Plan E carry explicit triggers; "is it time?" is a yes/no check, not a debate.
- Backlog promotion is auditable.
- Plan dirs B/D/E exist with overview only, signalling intent without pre-building speculative work.

Tradeoffs:

- Plan B running second means installer marker preservation is honour-system until Plan B's trigger fires. Acceptable; PATCH-EXTENSION-PROTOCOL.md documents the gap.
- Conditional gating for Plan E means it might never run. That is the correct outcome if Tier A items never surface friction.
- Plan E and Plan D may overlap if a Tier A pattern shows up in Plan D scope mid-execution. Plan D owner must check Plan E scope before adding to D.

## Follow-Up

- Create plan directories for B, C, D, E with plan.md only.
- Plan C gets full phase files (it is next in execution order).
- Add `B1`, `B2`, `B3`, `B5` to `docs/HARNESS_BACKLOG.md` with Demand evidence field (initial value: "none — waiting for promotion trigger").
- Add § Promotion Rule to `docs/HARNESS_BACKLOG.md` referencing this decision.
- When Plan B trigger fires, drop full phase files into `plans/260517-1242-lifecycle-gates-and-installer/`. Same for D after C, and E when its trigger fires.
