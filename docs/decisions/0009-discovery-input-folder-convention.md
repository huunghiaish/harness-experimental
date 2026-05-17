# 0009 Discovery Input Folder & Naming Convention

Date: 2026-05-17

## Status

Accepted

## Context

Same-day follow-up to decisions 0007 + 0008. During the solo-dev VN e-commerce project setup, the user dropped a Vietnamese source document at the repo root (`quy-trinh-solo-dev-vibecode-lam-viec-voi-khach-hang.md`). It served as the input that triggered `plans/reports/xia-260517-1538-solo-dev-vibecode-vs-harness.md` (audit), decision 0007 (commercial wrapper), and decision 0008 (visual modeling stage).

Two intermediate moves happened in the same session:

1. First, I moved the file to `plans/reports/` — incorrect; that folder holds agent-produced reports, not raw inputs.
2. The user redirected: "đây là input artifact giống SPEC.md, cần folder cho hình ảnh, meeting notes, change request raw."

`docs/HARNESS_BACKLOG.md` already carried a `proposed` entry "Standard file-naming convention for discovery artifacts (B1)" suggesting `docs/discovery/` with `YYYY-MM-DD-{kebab-slug}.{ext}` naming. Demand evidence was "None — waiting for promotion trigger (2 distinct projects OR 1 project × 3+ hits)". The current project is the first project, and within hours of needing the convention, it has been hit by both the user (filing the source doc) and the agent (mis-filing then re-filing) — call it 2 hits in spirit, plus future hits anticipated for upcoming meeting notes, screenshots, and CR raw messages.

The harness has SPEC.md at the repo root as the greenfield bootstrap input (per README.md). That precedent is intentional — SPEC.md is a singular boot input, not a recurring stream. For a stream of inputs throughout the project lifecycle, a dedicated folder is the right shape.

## Decision

Promote backlog entry B1 from `proposed` to `accepted`. Implement:

1. **Folder:** `docs/discovery/` is the canonical home for raw input artifacts received throughout the project lifecycle.

2. **Naming convention:** `YYYY-MM-DD-{kebab-slug}.{ext}`. Date = when the artifact was received or recorded, not when filed. Disambiguator suffix when multiple artifacts share a date.

3. **Scope of inputs that live here:**
   - Source documents (proposals, mockups, briefs from the client).
   - Meeting notes (kickoff, discovery, status, UAT).
   - Screenshots, mockups, design references.
   - Sample data exports (CSV, JSON anonymized fixtures).
   - Change-request raw messages (the email/chat the client sent — the structured log lives at `docs/templates/change-request-log.md`).
   - Voice-memo transcripts.
   - Third-party references (competitor analysis, regulatory excerpts).

4. **Excluded from this folder:**
   - Vendor-produced briefs (those live at `docs/intake/`).
   - Derived product contract (`docs/product/`).
   - Story packets (`docs/stories/`).
   - Decision docs (`docs/decisions/`).
   - Raw secrets, credentials, full-PII data (those go to the secret vault with a pointer file here).

5. **Structure:** flat by default. Sub-folders emerge only when 10+ files share a type OR binaries crowd markdown grep results. This matches the harness's "grows from friction" principle.

6. **Lifecycle:** append-only. Inputs are immutable after filing. Re-summaries become new dated files, not edits.

7. **Folder README:** `docs/discovery/README.md` documents the convention so a new agent or human can read the rule before adding their first input.

8. **First input filed:** `docs/discovery/2026-05-17-solo-dev-vibecode-workflow-vn.md` (the source document that drove decisions 0007 + 0008 + this decision).

9. **Installer sync:** `scripts/install-harness.sh` heredoc gains `docs/discovery/README.md` so new project installs get the convention pre-installed. The 2026-05-17 source file does NOT ship in the installer — it is project-specific content, not part of the portable harness.

10. **Reference update:** `docs/playbooks/solo-dev-client-delivery.md` adds a brief pointer that raw inputs land in `docs/discovery/`, not in `docs/intake/` (which is for vendor-produced briefs).

## Alternatives Considered

1. **Keep `plans/reports/source-260517-1646-*.md` location.** Rejected — `plans/reports/` holds agent-produced reports (xia audits, retro reports, etc.), not user-provided inputs. Mixing them collapses the read-cycle (inputs are inputs to thought; reports are outputs of thought).

2. **Top-level `inputs/` folder beside SPEC.md.** Rejected — adds top-level surface without strong precedent. AGENTS.md already routes "docs/" as the root for documentation. Keeping inputs under `docs/` preserves a single root for all docs/intake/discovery work.

3. **Rename to `docs/inputs/`** (more semantically clear than "discovery"). Considered but rejected — "discovery" matches the existing `docs/playbooks/discovery-interview-playbook.md` naming, providing concept consistency. "Inputs" is broader and could be confused with "input forms" or "input validation". Stick with "discovery".

4. **Pre-create sub-folders (meeting-notes/, screenshots/, change-requests/, references/, samples/) per ck:intake-file pattern.** Rejected — premature structure. Backlog B1 explicitly recommended leaving structure unprescribed. Sub-folders emerge from real friction.

5. **Defer until promotion trigger (2 distinct projects) is hit.** Rejected — the user is on a real client project NOW with the gap blocking immediate work. Sustained-pain trigger (1 project hit 3+ times) is being approached within this single session; preemptive promotion is cheaper than waiting.

6. **Add `docs/discovery/` mention to AGENTS.md § Source Of Truth.** Rejected for now — AGENTS.md is the operating model. Discovery inputs are pre-spec material, already covered by the new README. Updating AGENTS.md adds noise unless the input folder becomes a routine read-pass. Revisit if multiple projects need the cross-reference.

## Consequences

Positive:

- Clear, conventional home for raw inputs across the lifecycle (not just at kickoff like SPEC.md).
- The naming convention is `grep`-friendly: `grep -r 2026-05-17 docs/` surfaces every artifact from that day across discovery + downstream.
- Decisions and stories can cite inputs with a stable relative path that survives project growth.
- Append-only lifecycle prevents silent input rewrites that desync downstream artifacts.
- Installer ships the convention, not the example file — every harness install starts with the rule baked in.

Tradeoffs:

- A second folder under `docs/` (`discovery/`) plus existing `intake/` may confuse new contributors briefly. Mitigated by: README explicitly distinguishes "inputs (discovery/)" from "vendor-produced (intake/)".
- Sensitive content guardrails depend on discipline. Mitigated by: README explicit rule + reviewable git history.
- No INDEX.md by default — grep is the audit mechanism. If the folder grows past ~25 files without sub-folders, agents may struggle to navigate. Mitigated by: README documents the sub-folder promotion rule.
- Binary files (PNG, MP4) in git history bloat the repo. Mitigated by: README recommends sub-folder split when binaries crowd; future option of git-lfs or external storage with a pointer file (consistent with the secret-vault pattern).

## Follow-Up

- After 1 project completes with the convention in active use, re-evaluate the structure rule. Capture in a session retrospective: how many inputs accumulated, did sub-folders emerge naturally, was the date-prefix grep useful.
- If a project hits 25+ files without natural sub-folders, ship a small "discovery-index-generator" playbook OR start sub-folder structure with a follow-up decision.
- If binaries become a real problem, write a `git-lfs-for-discovery-inputs.md` playbook OR adopt an external-storage pointer pattern.
- Consider extracting a "discovery input checklist" template once the kinds of artifacts that recur are clearer (currently 7 listed in § Scope above).
- If 2+ projects request `INDEX.md` from day one, change the README default.

## Related

- `docs/HARNESS_BACKLOG.md` entry "Standard file-naming convention for discovery artifacts (B1)" — origin proposal, promoted by this decision.
- `docs/discovery/README.md` — convention reference for agents and humans.
- `docs/playbooks/discovery-interview-playbook.md` — the workflow that produces many of these inputs.
- `docs/playbooks/solo-dev-client-delivery.md` § 2-3 — consumers of discovery inputs.
- `docs/decisions/0007-solo-dev-client-delivery-templates.md`, `0008-visual-behavioral-modeling-stage.md` — same-session decisions that referenced the first filed input.
- README.md § Greenfield Bootstrap — SPEC.md precedent for top-level singular input.
