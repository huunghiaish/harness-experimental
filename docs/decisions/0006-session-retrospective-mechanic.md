# 0006 Session Retrospective Mechanic

Date: 2026-05-17

## Status

Accepted

## Context

The harness preaches "grows from friction" (HARNESS.md § Growth Rule) and
ships a per-task self-improvement checklist (AGENTS.md Task Loop step 9).
Both rely on agent discipline to surface friction back into the harness.

A multi-task session (e.g. the ClaudeKit Custom port executed across
2026-05-17, 11 commits) revealed a gap: per-task review captures
per-task friction, but session-level insight ("audit hidden coupling
before extending playbooks", "lifecycle status existed only after
explicit ask", "Plan B was almost shipped before Plan C without trigger
check") has no formal home. Insight that crosses tasks does not survive
into the next session unless the agent volunteers it.

The principles alone are insufficient when a careful operator could
still skip step 9 entirely without the harness noticing. A lightweight
mechanic is needed — heavy enough to be a routine, light enough not to
violate KISS.

## Decision

Adopt a two-piece session retrospective mechanic:

1. **Sharpen `AGENTS.md` Task Loop step 9** with three new bullets:
   - Lifecycle promotion check — did this work exercise an
     `experimental` playbook? If yes, was it usable without
     modification? If yes, promote to `verified` and fill the
     First-use field.
   - Playbook UX feedback — did any playbook used in this work
     require an unwritten workaround? If yes, append a § Variant
     section per `docs/playbooks/README.md` § Use Order.
   - Session-retro trigger — was this a multi-task session
     (3+ commits, or work spanning multiple intake items)? If yes,
     run `docs/playbooks/session-retrospective.md` before
     reporting "done".

2. **New playbook `docs/playbooks/session-retrospective.md`** —
   `experimental` lifecycle. Structured checklist the agent runs at
   session end. Output is a markdown report saved to
   `plans/reports/retro-<date>-<slug>.md`. Covers: tasks completed,
   friction encountered, playbooks used + UX rating, lifecycle
   promotion candidates, backlog candidates, decisions made, and
   recommendations for the next agent.

The two pieces compose: step 9 ensures every task closure considers
self-improvement; the session-retro playbook collects cross-task
insight that step 9's per-task scope misses.

## Alternatives Considered

1. **Sharpen step 9 only** (no session-retro playbook). Rejected —
   step 9 is still per-task, so cross-task insight remains
   un-captured.
2. **Build a `scripts/end-of-session-report.sh` script** that auto-
   collects git diff and prompts for retro. Rejected — violates
   Independence Principle (operating model would gain a runtime
   dependency) and is premature.
3. **Treat retrospective as a one-off doc per session, no playbook
   needed.** Rejected — without a playbook, the format drifts, and
   future agents have no canonical shape to follow.
4. **Add retrospective as a STORY shape** (sibling to
   `delivery-closure-story/`). Rejected — retrospectives summarise
   work but are not themselves units of work. Playbook is the right
   shape; the report it produces is the artifact.

## Consequences

Positive:

- Session-level insight has a formal home, not just agent memory.
- Lifecycle promotion check unlocks the `experimental → verified`
  state transition that was added in the prior session but had no
  trigger to fire.
- Playbook UX feedback closes the loop between playbook authors and
  playbook users — each use either confirms the recipe or appends a
  Variant.
- `plans/reports/retro-*.md` becomes a searchable archive of "what
  did we learn that session?"

Tradeoffs:

- Multi-task sessions add a small closing step (~5-15 min retro fill).
- Risk: agent may treat the retro playbook as ceremony and emit
  thin reports. Mitigated by the playbook's structured prompts —
  thin retros are visibly thin.
- Slight added ceremony violates KISS in marginal cases. Mitigated
  by the 3+ commits trigger — single-task sessions are exempt.

## Follow-Up

- Apply the new mechanic to the current session as a worked example
  (`plans/reports/retro-260517-1451-claudekit-custom-port.md`).
- After 3 sessions use the retrospective playbook, evaluate whether
  to promote it from `experimental` to `verified` and whether any
  Variant sections accumulated.
- If retro reports surface the same friction across 3+ sessions,
  promote to backlog via the standard rule.
