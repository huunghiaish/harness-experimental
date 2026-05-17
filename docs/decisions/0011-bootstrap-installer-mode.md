# 0011 Bootstrap Mode For install-harness.sh

Date: 2026-05-17

## Status

Accepted

## Context

`scripts/install-harness.sh` assumed the target directory was an existing project. Greenfield bootstrap required four manual steps (`mkdir`, `curl install`, place SPEC, `git init && commit`), documented in README § Greenfield Bootstrap. `docs/HARNESS_BACKLOG.md` carried a `proposed` entry "Bootstrap mode for `install-harness.sh`" suggesting a `--bootstrap` flag that bundles those steps.

Demand evidence: the pre-flight audit for the user's first real paid client project (2026-05-17, single-project sustained-pain trigger per decision 0005 § 5) flagged this as a Critical fix before opening the project. The user will hit the manual path immediately when starting; the friction is concrete and imminent.

Decision 0009 (discovery folder convention) further changed the bootstrap shape: the initial spec no longer lands at `./SPEC.md` but at `docs/discovery/YYYY-MM-DD-initial-spec.<ext>`. The bootstrap flag therefore also handles the spec placement step.

## Decision

Promote backlog entry "Bootstrap mode for `install-harness.sh`" from `proposed` to `accepted`. Implement:

1. **`--bootstrap` flag** on the installer:
   - Implies `--yes` + `--override` + `--force` (non-interactive, backs-up-then-replaces protected paths, overwrites existing files with backups).
   - After successful copy, runs `git init` in the target if no `.git` directory exists (silently skips if `git` is not on PATH).
   - Prints a "next step" prompt that the user can paste verbatim into Claude Code (or any AGENTS.md-aware agent) to start Phase 1 spec intake.
2. **`--spec <path>` option** (requires `--bootstrap`):
   - Copies the given file to `docs/discovery/YYYY-MM-DD-initial-spec.<ext>` where the date is today and the extension is inherited from the source filename (default `md` if none).
   - Skips silently if the target file already exists (idempotent re-runs).
   - Fails fast if the source file does not exist.
3. **`--dry-run` compatibility**: bootstrap respects dry-run (prints intent, writes nothing).
4. **Reconciliation with decision 0009**: README + WORKFLOW + FEATURE_INTAKE already updated (commit `docs(harness): clarify spec-intake reads docs/discovery/* not root SPEC.md`) to point the greenfield path at `docs/discovery/` instead of `./SPEC.md`.

The single-command equivalent of the previous four-step greenfield path is:

```bash
curl -fsSL https://raw.githubusercontent.com/huunghiaish/harness-experimental/main/scripts/install-harness.sh \
  | bash -s -- --bootstrap --spec /path/to/spec.md ./my-new-project
```

## Alternatives Considered

1. **Keep manual four-step path** — rejected: user-facing friction is high (every greenfield project re-runs the same four commands), and the spec-placement step is error-prone (wrong filename, wrong folder, missed date prefix).
2. **Separate `bootstrap-harness.sh` wrapper script** — rejected: doubles maintenance surface; the install-harness.sh script already owns file copy + conflict resolution; adding 60 lines is cheaper than a sibling script.
3. **`--bootstrap` without `--spec` (require user to drop files manually after)** — viable but worse UX. The `--spec` add-on is cheap (15 lines) and removes the most common case where the user has exactly one spec file ready.

## Consequences

Positive:

- One-line greenfield bootstrap.
- The "next step" prompt eliminates the most-common follow-up question ("what do I tell Claude Code?").
- Aligns README + installer with decision 0009 — no more SPEC.md drift.

Tradeoffs:

- `--bootstrap` is destructive on a populated target (override + force). Mitigated by: backups written under `.harness-backup/<timestamp>/` like the existing `--force` path.
- `--spec` accepts any extension. If the user passes a binary file (e.g. `.pdf`), it lands in `docs/discovery/` correctly per the convention, but downstream agents need to handle the binary read.
- `git init` runs unconditionally if `.git` is absent. If the user intended `git init` later with a non-default branch name or signing config, they will need to reconfigure. Acceptable — this is a greenfield bootstrap; opinionated defaults are appropriate.

## Follow-Up

- Update `docs/HARNESS_BACKLOG.md` to mark the item `accepted` with reference to this decision (handled in cleanup task Q3 of pre-flight fixes plan).
- Future enhancement (deferred): `--spec <path>` could be extended to `--inputs <dir>` for multi-file initial drops, but a single starter file is the 80% case.

## Addendum — 2026-05-17 (initial commit on bootstrap)

Demand evidence: same-day friction. After running `--bootstrap`, the user still had to `git add -A && git commit` manually before phase 1 — otherwise the first phase-1 commit (`docs/intake/…`) would silently absorb the entire harness scaffold and discovery spec, polluting the diff that reviewers actually need to read.

Decision extension: when `--bootstrap` runs **and** the installer created `.git` itself (i.e. `.git` did not exist before this invocation), the installer now also stages everything (`git add -A`) and creates an initial commit with message `chore: bootstrap harness scaffold` (or `… + initial discovery spec` when `--spec` was provided).

Skipped cases (no auto-commit):

- `.git` already existed before installer ran → installer leaves git history untouched. The user owns the existing repo's working tree state and is expected to commit on their own cadence.
- `HEAD` already exists in the newly created repo (e.g. concurrent git activity) → installer skips with a log line, does not overwrite.
- `--dry-run` → no git operations.
- `git` not on PATH → already skipped by the prior `git init` guard.

Identity: the commit uses the user's existing global `git config user.email` / `user.name` when present. Only when no identity is configured does the installer fall back to a generic `Harness Bootstrap <harness-bootstrap@local>` author so the commit can be created at all. `--no-verify` and `--no-gpg-sign` are used because a greenfield target has no hooks or signing keys configured yet — the user opts into both on their next normal commit.

Why this matters: phase 1's intake commit should diff cleanly against a baseline that represents *just the harness*. Without the auto-commit, the phase-1 diff balloons by hundreds of files and stops being reviewable. The auto-commit is the minimum git work needed to make phase 1's first deliverable readable.

Cross-reference: `docs/QUICKSTART.md` § 0 (Verify install) — describes the post-bootstrap git state the user should expect. Generalised by `docs/decisions/0012-stage-boundary-commits.md` (this addendum is the case-zero of that broader rule).

## Cross-Reference

- `docs/HARNESS_BACKLOG.md` — "Bootstrap mode for `install-harness.sh`" original proposal.
- `docs/decisions/0009-discovery-input-folder-convention.md` — discovery folder convention this builds on.
- `docs/decisions/0005-roadmap-execution-direction.md` § 5 — single-project sustained-pain promotion rule applied here.
- `README.md` § Greenfield Bootstrap — updated user-facing path.
- `docs/FEATURE_INTAKE.md` § Spec Approval Gate — what the "next step" prompt triggers.
- `plans/reports/review-260517-1728-pre-flight-workflow-audit.md` § C3 — pre-flight audit that surfaced this.

