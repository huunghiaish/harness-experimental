# Patch Extension Protocol

Non-destructive way for an org or project to inject local extensions into the
harness's playbooks and templates without forking the whole repo.

## When To Use

Use this when:

- An org needs to add a step, gate, or note to a shipped playbook (regional
  approver, security check, comms channel).
- The change is org-local and should NOT propagate upstream.

Do NOT use this for:

- Changes to `AGENTS.md`, `docs/HARNESS.md`, `docs/FEATURE_INTAKE.md`, or
  `docs/ARCHITECTURE.md`. These are the operating contract — if you need to
  change them, fork the harness.
- New playbooks. Add new playbook files directly; markers are for amending
  existing ones.

## Marker Syntax

```text
<!-- HARNESS:EXT:START {slug} -->
[any markdown content — appended block]
<!-- HARNESS:EXT:END {slug} -->
```

Rules:

- `{slug}` is kebab-case and unique within the file. Example:
  `acme-regional-approver`.
- Both markers must be present. An orphan START or END is invalid.
- Content between markers is the org's; the harness installer must NOT
  overwrite it.

## Where Markers May Appear

| File path | Patchable? |
| --- | --- |
| `docs/playbooks/*.md` (except `README.md` and `template.md`) | yes |
| `docs/templates/**/*.md` | yes |
| `docs/HARNESS.md`, `AGENTS.md`, `docs/FEATURE_INTAKE.md`, `docs/ARCHITECTURE.md` | no — fork instead |
| `docs/decisions/*.md` | no — write a new superseding decision |
| `docs/playbooks/README.md` | no — register playbooks by editing the index directly |

## Worked Example

To add an "Acme regional approver" step to the UI design system contract
playbook, append this block at the end of
`docs/playbooks/ui-design-system-contract.md`:

```markdown
<!-- HARNESS:EXT:START acme-regional-approver -->

### Acme Regional Approver Step

Before the §13 verification gate signs off, the EMEA design lead must
approve the contract file via Slack workflow `#design-emea-approval`.

<!-- HARNESS:EXT:END acme-regional-approver -->
```

A future harness installer pass (Plan B) will preserve this block when
re-installing or upgrading. Until that installer pass lands, treat the
markers as a hand-merge contract: the maintainer running `install-harness.sh`
must check for `HARNESS:EXT` blocks before approving an override.

## Anti-Patterns

- **Nested markers.** Do not place an `EXT:START` inside another `EXT:START`
  block.
- **Generic slugs** like `extension-1`. Use a descriptive kebab-case slug
  that says who owns it and what it does (`acme-regional-approver`,
  `securityteam-prod-gate`).
- **Patching operating-model docs.** Use a fork instead — operating-model
  dialects break cross-team trust.
- **Markers in the README index.** Edit the index inline, then add the new
  file.

## Removal

To remove an extension:

1. Find both markers: `grep -A 100 "HARNESS:EXT:START acme-regional-approver" <file>`.
2. Delete everything from START to END inclusive.
3. Commit with a message stating which extension was removed and why.

## Audit

To list every active extension across the harness:

```bash
grep -rn "HARNESS:EXT:START" docs/playbooks docs/templates
```

This is the canonical inventory. If a block exists without a matching END
marker, treat it as broken — open the file and fix the pair.
