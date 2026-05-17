# Phase 02 — Patch Extension Protocol

## Context Links

- Parent plan: `plan.md`
- Decision: `docs/decisions/0004-adopt-claudekit-custom-patterns.md` § Decision item 2.
- Source pattern: ClaudeKit Custom `<!-- CK-CUSTOM:START {slug} --> ... <!-- CK-CUSTOM:END {slug} -->`
  used across `~/Projects/claudekit-custom/patches/`.

## Overview

- **Priority:** Second — produces the marker contract that Plan B (installer marker-preserve) will enforce.
- **Status:** pending.
- **Brief:** Document the patch-extension protocol so teams can inject local extensions into playbooks
  and templates without forking the whole harness, while operating-model docs stay read-only.

## Key Insights

- Marker pattern is non-destructive: `grep "HARNESS:EXT:START" docs/` lists every active patch.
- Renaming the marker from `CK-CUSTOM` to `HARNESS:EXT` makes ownership obvious.
- Scope rule is the key insight: playbooks/templates patchable; operating-model docs NOT patchable
  (must fork). This preserves contract coherence cross-team.
- Plan B will add installer logic to PRESERVE these markers on `--override`. Phase 02 only specifies
  the contract; installer change is Plan B work.

## Requirements

Functional:
- New file `docs/playbooks/PATCH-EXTENSION-PROTOCOL.md` documenting marker syntax + scope rules + example.
- `docs/playbooks/README.md` gains entry under "Structural framework" group linking to the protocol.
- No installer change in this phase.

Non-functional:
- Under 120 lines (terse).
- One concrete example (preferred: extending the `ui-design-system-contract.md` with an org-specific
  approval gate).

## Architecture

```text
docs/playbooks/
├── PATCH-EXTENSION-PROTOCOL.md          ← NEW
│   ├─ marker syntax (HARNESS:EXT:START/END {slug})
│   ├─ scope rule (what can be patched, what cannot)
│   ├─ example (one playbook patched with org rule)
│   └─ anti-patterns (do not patch AGENTS.md / HARNESS.md / FEATURE_INTAKE.md)
└── README.md (updated)
    └─ new row under "Structural framework" group
```

## Related Code Files

To modify:
- `docs/playbooks/README.md` — add row in "Structural framework" group.

To read for context:
- `~/Projects/claudekit-custom/patches/*.md` (any 1 — to see marker idiom in action).
- `docs/playbooks/template.md` (for shape inspiration).

To create:
- `docs/playbooks/PATCH-EXTENSION-PROTOCOL.md`.

To delete:
- None.

## Implementation Steps

1. Skim 1 file in `~/Projects/claudekit-custom/patches/` to see marker idiom (5 min).
2. Draft `PATCH-EXTENSION-PROTOCOL.md` from the skeleton below.
3. Add a worked example: take `ui-design-system-contract.md` and show how an org would patch in a
   "regional approver" step. Do not actually modify `ui-design-system-contract.md`; the example
   lives inside the protocol file as a fenced markdown block.
4. Update `docs/playbooks/README.md` — add one row in "Structural framework" group:
   `[PATCH-EXTENSION-PROTOCOL.md](PATCH-EXTENSION-PROTOCOL.md) | Non-destructive marker pattern for adding org-specific extensions to playbooks and templates without forking the harness.`
5. Grep verify: `grep -l "HARNESS:EXT:START" docs/playbooks/PATCH-EXTENSION-PROTOCOL.md` returns the file.
6. Commit: `docs(playbooks): add patch extension protocol (HARNESS:EXT markers)`.

## File Draft Skeleton (paste into docs/playbooks/PATCH-EXTENSION-PROTOCOL.md)

```markdown
# Patch Extension Protocol

Non-destructive way for an org or project to inject local extensions into the
harness's playbooks and templates without forking the whole repo.

## When To Use

Use this when:
- An org needs to add a step, gate, or note to a shipped playbook (regional
  approver, security check, comms channel).
- The change is org-local and should NOT propagate upstream.

Do NOT use this for:
- Changes to `AGENTS.md`, `HARNESS.md`, `FEATURE_INTAKE.md`, or `ARCHITECTURE.md`.
  These are the operating contract. If you need to change them, fork the harness.
- New playbooks. Add new playbook files directly — markers are for amending
  existing ones.

## Marker Syntax

```text
<!-- HARNESS:EXT:START {slug} -->
[any markdown content — appended block]
<!-- HARNESS:EXT:END {slug} -->
```

Rules:
- `{slug}` is kebab-case and unique within the file. Example: `acme-regional-approver`.
- Both markers must be present. An orphan START or END is invalid.
- Content between markers is the org's; the harness installer must NOT overwrite it.

## Where Markers May Appear

| File path | Patchable? |
| --- | --- |
| `docs/playbooks/*.md` (except `README.md` and `template.md`) | yes |
| `docs/templates/**/*.md` | yes |
| `docs/HARNESS.md`, `docs/AGENTS.md`, `docs/FEATURE_INTAKE.md`, `docs/ARCHITECTURE.md` | no — fork instead |
| `docs/decisions/*.md` | no — write a new superseding decision |
| `docs/playbooks/README.md` | no — register playbooks by editing the index directly |

## Worked Example

To add an "Acme regional approver" step to the UI design system contract playbook,
append this block at the end of `docs/playbooks/ui-design-system-contract.md`:

```markdown
<!-- HARNESS:EXT:START acme-regional-approver -->

### Acme Regional Approver Step

Before the §13 verification gate signs off, the EMEA design lead must approve
the contract file via Slack workflow `#design-emea-approval`.

<!-- HARNESS:EXT:END acme-regional-approver -->
```

The harness installer will preserve this block when re-installing or upgrading.

## Anti-Patterns

- Nested markers. Do not place an `EXT:START` inside another `EXT:START` block.
- Generic slugs like `extension-1`. Use a descriptive kebab-case slug.
- Patching operating-model docs. Use a fork instead — operating-model dialects
  break cross-team trust.
- Markers in the README index. Edit the index inline, then add the new file.

## Removal

To remove an extension:
1. Find both markers: `grep -A 100 "HARNESS:EXT:START acme-regional-approver" <file>`.
2. Delete everything from START to END inclusive.
3. Commit.
```

## Todo List

- [ ] Skim one CK-CUSTOM patch file for marker idiom.
- [ ] Draft `docs/playbooks/PATCH-EXTENSION-PROTOCOL.md` using skeleton above.
- [ ] Update `docs/playbooks/README.md` index.
- [ ] Grep verify.
- [ ] Commit.

## Success Criteria

- `docs/playbooks/PATCH-EXTENSION-PROTOCOL.md` exists, under ~120 lines.
- `docs/playbooks/README.md` "Structural framework" group lists the new file.
- File contains at least one worked example using `HARNESS:EXT` marker.

## Risk Assessment

Tiny. Docs only. Installer enforcement comes in Plan B; meanwhile teams can adopt the marker
manually and we can hand-merge on the next install.

## Security Considerations

None. Marker pattern is plain markdown comment.

## Next Steps

- Plan B: update `scripts/install-harness.sh` to preserve marker blocks on `--override` and
  `--merge` modes. Add a test fixture.
