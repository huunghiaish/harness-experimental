# Code Standards

> Stub. Populated at stage 5 (Spec + Design intake) right after the stack-selection decision lands. Keep it short — long standards docs rot. One page is the target.
>
> Once filled, this file moves to `docs/code-standards.md` (project root of `docs/`). Cited from `docs/HARNESS.md § Project Doc Mapping`.

## Source-Of-Truth Stack

| Item | Choice | Decision |
| --- | --- | --- |
| Runtime / language version | `<e.g. Node.js 22 LTS, Python 3.12, Go 1.23>` | `docs/decisions/NNNN-stack-selection.md` |
| Primary framework | `<e.g. NestJS, FastAPI, Next.js App Router>` | same |
| Package manager | `<e.g. pnpm 9, uv, go modules>` | same |
| Linter | `<e.g. eslint + @typescript-eslint, ruff, golangci-lint>` | — |
| Formatter | `<e.g. prettier, ruff format, gofmt>` | — |
| Type checker | `<e.g. tsc strict, mypy strict, native>` | — |

## File & Folder Naming

- File names: `<convention — kebab-case / snake_case / PascalCase per language ecosystem>`.
- Folder names: `<convention>`.
- Test files: `<convention — *.test.ts / test_*.py / *_test.go>`.
- Story tokens cited in commit body: `US-NNN.REQ-MMM` / `US-NNN.SC-MMM` (see `docs/HARNESS.md § Traceability Tokens`).

## Imports

- Order: `<stdlib → third-party → workspace → local relative>`.
- Absolute path aliases: `<list or "none">`.

## Error Handling

- Boundary parse rule: per `docs/ARCHITECTURE.md § Parse-First Boundary Rule`. Unknown input → parser → typed DTO → use case.
- Error envelope (HTTP / API): `<shape — e.g. { error: { code, message, details } }>`.
- Logging on error: `<rule — e.g. log at boundary only, never inside domain>`.

## Logging

Single canonical JSON line per request per `docs/ARCHITECTURE.md § Observability Contract`.

- Logger: `<library>`.
- Format: JSON, single-line, fields per ARCHITECTURE contract.
- Audit logs vs application logs: per ARCHITECTURE — audit is product record, app log is operational record.

## Testing Convention

- Unit test framework: `<e.g. vitest, pytest, go test>`.
- Integration: `<framework + fixture strategy>`.
- E2E: `<framework — Playwright / Cypress / Detox>`.
- Coverage target: `<percentage or "see TEST_MATRIX">`. Token-based coverage in `docs/TEST_MATRIX.md` is the contract; raw % is informational.

## Commit Message Format

Conventional commits. Body cites at least one composite token (`US-NNN.REQ-MMM`, `US-NNN.SC-MMM`, or `US-NNN.TC-MMM`) per `docs/HARNESS.md § Traceability Tokens` and `docs/playbooks/build-execution.md` § Commit Hygiene.

```text
<type>(<scope>): <subject>

<body — explain WHY, cite at least one US-NNN.* token>
```

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`, `style`, `build`, `ci`.

## Pre-Commit Hooks

Recipe in `docs/playbooks/build-execution.md` § Pre-Commit Hook Recipe.

## Cross-Reference

- `docs/HARNESS.md § Project Doc Mapping` — why this file exists.
- `docs/decisions/NNNN-stack-selection.md` — authority for the stack rows above.
- `docs/ARCHITECTURE.md` — parse-first and layering rules referenced here.
- `docs/playbooks/build-execution.md` — pre-commit recipe + branching strategy.
