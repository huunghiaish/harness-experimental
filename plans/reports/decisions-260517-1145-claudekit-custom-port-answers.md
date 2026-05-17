# Answers — 5 Open Questions from ClaudeKit Custom Scan

**Date:** 2026-05-17 · **Companion:** `xia-260517-1130-claudekit-custom-skill-scan.md`

These are opinionated answers, not decisions. Treat as recommended direction; promote to `docs/decisions/` if accepted.

---

## Q1 — Standardize REQ-XXX / SC-XXX tokens officially?

**Answer:** Yes, but soft. Tiered like intake.

**Why:**
- Tokens enable grep-audit across stories → matrix → decisions. Harness already has TEST_MATRIX behavior-to-proof — tokens make rows cite-able.
- Tiny lane doesn't need them; forcing tokens on a docs typo is ceremony for nothing.
- ck:rri/scenario/e2e-flow naturally emit REQ-/SC-/TC- — alignment with adjacent tooling is free portability.

**Recommendation:**
- Add §"Traceability Tokens" to `docs/HARNESS.md` defining prefix convention: `REQ-` (requirement), `SC-` (scenario/edge), `TC-` (test case), `DEC-` (decision), `STR-` (story).
- Required for **normal** + **high-risk** lanes. Optional for **tiny**.
- TEST_MATRIX rows MUST cite the token they prove.

**Risk:** Tiny. Convention only; no automation needed.

---

## Q2 — Patch markers for playbooks: extension system or read-only?

**Answer:** Extension system for playbooks only. Read-only for `AGENTS.md` / `HARNESS.md` / `FEATURE_INTAKE.md`.

**Why:**
- Playbooks are CROSS-PROJECT recipes; orgs need to inject local rules (SLA, gating, comms) without forking the whole harness.
- Curl installer overwrites on re-install — patches inside marker blocks survive if installer respects them.
- Operating model docs (`AGENTS.md` et al.) must stay coherent. Patching them creates per-org dialects of the agent rules — that's a fork, not an extension.

**Recommendation:**
- Use marker `<!-- HARNESS:EXT:START {slug} -->` ... `<!-- HARNESS:EXT:END {slug} -->` (rename from CK-CUSTOM so ownership is obvious).
- Document protocol in `docs/playbooks/.PATCH-EXTENSION-PROTOCOL.md`.
- Update `scripts/install-harness.sh` to preserve marker blocks on `--override` (merge-mode already preserves).
- Boundary rule: playbooks, templates → patchable. Operating-model docs → not patchable; fork instead.

**Risk:** Normal. Touches installer behavior.

---

## Q3 — Hypercare + production-readiness: in Task Loop or optional?

**Answer (revised 2026-05-17 — user approved):** Optional playbooks WITH auto-trigger rule for high-risk lane.

**Why:**
- Harness Task Loop is per-story. Hypercare + prod-readiness are project-lifecycle, not story-scope. Forcing them into Task Loop bloats every task.
- Harness already excludes deployment/CI/infra concerns from v0. Adding post-release phase before there's even one production story violates "grows from friction".
- BUT: leveraging the existing tier model (tiny/normal/high-risk) lets us protect risky stories without quarantining tiny/normal. High-risk lane already requires `execplan/design/validation` — adding a prod-readiness reference is a 1-line template addition.
- Hypercare stays purely optional (only relevant post-ship).

**Recommendation:**
- Add as playbooks under **Workflow recipe** group:
  - `docs/playbooks/production-readiness-checklist.md` (pre-ship gate)
  - `docs/playbooks/hypercare-plan.md` (post-go-live support shape)
- In `docs/templates/high-risk-story/execplan.md`: add a line "If this story moves to production, link to `production-readiness-checklist` playbook before merge."
- Reference from `AGENTS.md` as optional hooks; do NOT add to step 9 (the "before finishing" questions) — keep that focused on single-story state.

**Risk:** Tiny. Docs + template addition only.

---

## Q4 — Bilingual (VN/EN) template support built-in?

**Answer:** No. Document the PATTERN, don't ship the locale.

**Why:**
- Harness ships via curl installer to any project, anywhere. Baking VN into upstream templates assumes audience and inflates token cost for orgs that don't need it.
- ck:* skills are inherently VN-aware because they target VN SME clients — that's a deliberate scope choice, not a harness default.
- Bilingual is a PATTERN (titles in locale, automation/IDs in English), reusable for any locale pair.

**Recommendation:**
- Add `docs/playbooks/bilingual-delivery-template-pattern.md` describing the fork pattern:
  - Keep automation, IDs, tokens, code fences in English (universal).
  - Translate titles, instructions, client-facing copy.
  - Encode locale in path: `templates/locale-vi/` next to default `templates/`.
- Do NOT pre-translate any template. Let regional forks emerge.

**Risk:** Tiny.

---

## Q5 — Aggregator composition pattern: port as meta-playbook?

**Answer:** Yes, as a single playbook under **Structural framework** group. Do NOT pre-build any aggregators.

**Why:**
- Aggregator pattern (ck:ux-design wraps 5 sub-skills) is the KIND of insight playbooks should carry — portable, agent-readable, reduces cognitive load.
- Pre-building aggregators violates harness's "grows from friction" rule — wait until real demand surfaces a sequence worth wrapping.
- The PATTERN is the durable artifact; the specific aggregators are project/team-specific.

**Recommendation:**
- Add `docs/playbooks/playbook-composition-pattern.md` covering:
  - When to compose: 3+ playbooks always run in the same order; user friction in remembering order; output of one feeds next.
  - When to KEEP atomic: any combination might run independently; sub-playbooks have separate failure recovery.
  - Composition shape: a "meta-playbook" file that links sub-playbooks in order with hand-off contract per step (input/output/skip-when).
  - Idempotency + freshness check pattern (port from ck:design-system `check_freshness.py`): skip rerun if output <N days old, `--regenerate` override.
- Resist building `full-discovery-playbook.md` or similar until at least one project shows the friction.

**Risk:** Tiny.

---

## Net Roadmap Implication

Accepting all 5 answers yields ~4 new playbook entries + 1 HARNESS.md addition + 1 installer change:

| Item | File | Effort |
|------|------|--------|
| Traceability tokens §  | `docs/HARNESS.md` | 30m |
| Patch extension protocol | `docs/playbooks/.PATCH-EXTENSION-PROTOCOL.md` | 1-2h |
| Installer marker preserve | `scripts/install-harness.sh` | 1h |
| Production readiness checklist playbook | `docs/playbooks/production-readiness-checklist.md` | 1h |
| Hypercare plan playbook | `docs/playbooks/hypercare-plan.md` | 1h |
| Bilingual template pattern | `docs/playbooks/bilingual-delivery-template-pattern.md` | 30m |
| Composition pattern | `docs/playbooks/playbook-composition-pattern.md` | 1h |

**Plus the 3 Tier-S actions from prior report** (discovery interview, scenario template, delivery-closure story) → total ~14-18h work.

Recommend slicing into 2 plans:
1. **Plan A — Conventions + Protocol** (Q1, Q2, Q4, Q5 answers): token convention, patch protocol, bilingual pattern, composition pattern. Low risk, high leverage, no installer change.
2. **Plan B — Lifecycle Playbooks + Discovery** (Q3 + Tier-S actions): prod-readiness, hypercare, discovery interview, scenario template, delivery closure. Installer change.

---

## Unresolved (escalate to user before any of this lands)

1. **Installer marker-preserve behavior:** Should `--override` preserve `HARNESS:EXT` blocks, or wipe everything? My recommendation is preserve, but it changes installer contract.
2. **Token convention vs existing story IDs:** `docs/stories/epics/E02-access-control/US-014-...` already exists. Does `REQ-` replace, augment, or co-exist with `US-`/`E0X-`? Recommend co-exist (US = story id, REQ = requirement contained in story).
3. **Bilingual playbook scope:** If we ship the pattern but no locale files, does the README installer one-liner need to mention how to fork into a locale variant?
