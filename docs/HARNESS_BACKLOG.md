# Harness Backlog

Use this file when an agent discovers a missing harness capability but should
not change the operating model immediately.

## Template

```md
## Missing Harness Capability

### Title

Short name.

### Discovered While

Task or story that exposed the gap.

### Current Pain

What was hard, repeated, ambiguous, or unsafe?

### Suggested Improvement

What should be added or changed?

### Risk

Tiny, normal, or high-risk.

### Status

proposed | accepted | implemented | rejected
```

## Items

## Missing Harness Capability

### Title

Dynamic file discovery for `install-harness.sh`

### Discovered While

Auditing the install script after a user asked which install method to
prefer for greenfield (2026-05-17). Found three newly-shipped playbooks
(`e2e-recording-user-guide-quality.md`, `e2e-qa-field-by-field-verify-with-report.md`,
`ui-design-system-contract.md`) silently absent from the hardcoded
`HARNESS_FILES` list — anyone who curl-installed after 2026-05-16 was
missing them. Patched the list immediately, but the root cause is the
hardcoded approach.

### Current Pain

`scripts/install-harness.sh` ships files via a hardcoded heredoc list
at lines 357-387. Every new playbook, template, or doc requires manual
list maintenance. No CI guard detects drift between repo state and
shipped state. Authors of new files have no signal that their work
won't reach installer users until someone notices the gap weeks later.

### Suggested Improvement

Pick one of three approaches:

1. **Tarball download** — fetch a tarball of the repo at `main`, extract
   only the shipped paths (`AGENTS.md`, `docs/`, `scripts/`). Simpler,
   one network call, naturally picks up new files.
2. **GitHub API directory listing** — query `/repos/.../contents/docs`
   recursively, copy matching paths. More requests but no shell-list
   maintenance.
3. **Hardcoded list with CI guard** — keep current approach but add a
   CI step that diffs the heredoc against `git ls-files` filtered to
   shipped paths and fails on drift.

Option 1 is simplest to implement; option 3 is cheapest to ship today.

### Risk

Normal — install correctness is high-leverage but the fix is contained
to one script.

### Status

proposed

## Missing Harness Capability

### Title

Bootstrap mode for `install-harness.sh`

### Discovered While

Documenting greenfield workflow from `SPEC.md` (2026-05-17).

### Current Pain

`install-harness.sh` assumes the target directory is an existing project
(prompts to merge / override / stop on existing files). Greenfield
projects starting from a written spec require manual steps:
`git clone` the harness, `rm -rf .git && git init`, manually place
`SPEC.md`. The README's "Greenfield Bootstrap" section now documents
this manual path, but it should be a single command.

### Suggested Improvement

Add a `--bootstrap` flag that:
1. Initializes a fresh git repo in the target directory.
2. Copies all harness files unconditionally (no merge prompts).
3. Optionally accepts `--spec <path>` to copy the user's spec to
   `./SPEC.md` in one step.
4. Prints the "next prompt" (the Claude Code prompt that runs Phase 1
   intake) so the user can copy-paste straight in.

### Risk

Normal.

### Status

proposed

