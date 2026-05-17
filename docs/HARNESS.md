# Harness

The project goal is to provide a reusable operating harness that lets humans and
agents turn a future product spec into safe, validated work.

The app is what users touch. The harness is what agents touch.

## Mental Model

```text
------------------+
| Human intent    |
+------------------+
         |
         v
+------------------+
| Feature intake   |
+------------------+
         |
         v
+------------------+
| Story packet     |
+------------------+
         |
         v
+------------------+
| Agent work loop  |
+------------------+
         |
         v
+------------------+
| Product delta    |
+------------------+
         |
         v
+------------------+
| Validation proof |
+------------------+
         |
         v
+------------------+
| Harness delta    |
+------------------+
         |
         v
+------------------+
| Next intent      |
+------------------+
```

Every task has two possible outputs:

1. Product delta: app code, tests, API shape, data model, or product docs.
2. Harness delta: docs, templates, validation expectations, backlog items,
   decision records, or **playbook entries** that make the next task easier.

Playbooks are the cross-project memory layer of the harness — each entry
turns a one-time fix into a portable recipe, so a sibling project running the
same Harness installer inherits the answer instead of re-deriving it.

## Harness v0 Scope

Harness v0 includes:

- Agent entrypoint.
- Empty product documentation structure.
- Feature intake and risk lanes.
- Story templates.
- Decision log template.
- Validation report template.
- Test matrix placeholder.
- Harness growth backlog.
- Playbooks folder for reusable cross-project recipes.

Harness v0 deliberately excludes:

- A project-specific `SPEC.md`.
- Pre-sliced product domains.
- A locked application stack.
- App source scaffolding.
- Package scripts.
- Test runner config.
- CI workflows.
- Database migrations or infrastructure.

Those should arrive only when a selected story needs them.

## Source Hierarchy

```text
User-provided spec or prompt
  input material for first buildout or future changes

docs/product/*
  current product contract derived from accepted input

docs/stories/*
  story-sized work packets and historical evidence

docs/TEST_MATRIX.md
  behavior-to-proof control panel

docs/decisions/*
  why the contract changed
```

Before implementation, product docs describe intent. After implementation,
product docs plus executable tests become the living contract.

## Traceability Tokens

The harness uses prefixed IDs so that requirements, scenarios, tests, and
stories can be cross-referenced by `grep` across `docs/`. Token format follows
three rules:

1. **Top-level IDs keep their existing form.** Stories use `US-NNN`
   (e.g. `US-014`), epics use `E0X-kebab-name` (e.g. `E02-access-control`),
   decisions use `NNNN` 4-digit without prefix (e.g. `0004`). Do not rename
   them.
2. **Sub-story IDs use composite form** `US-NNN.PREFIX-MMM` where PREFIX is
   one of:

   | Prefix | Means | Lives in |
   | --- | --- | --- |
   | REQ | A discrete requirement inside a story | story packet |
   | SC | A scenario / edge case to prove | scenario notes or test plan |
   | TC | A test case (manual or automated) | TEST_MATRIX row, test file name |

   Example: `US-014.REQ-001`, `US-014.SC-003`, `US-014.TC-007`. Composite
   scope keeps numbering local to the story (no cross-story counter to
   manage) and forces `grep` callers to cite the full composite for audit.
3. **TEST_MATRIX rows cite the token they prove.** Any row in
   `docs/TEST_MATRIX.md` must reference at least one composite token in its
   Contract column.

Per-lane application:

| Lane | Token use |
| --- | --- |
| Tiny | Optional. Inline narrative is fine. |
| Normal | Required for any new requirement or scenario the story introduces. |
| High-risk | Required. Every entry in `execplan.md`, `design.md`, `validation.md` must reference its tokens. |

Reject `STR-` and `DEC-` prefixes — `US-` and 4-digit decision numbering
already cover those concepts.

## Spec Lifecycle

Harness v0 starts without a tracked project spec. When the human provides a
specification, treat it as input material, not as a permanent operating manual.
Use it to populate product docs, story packets, architecture decisions, and
validation expectations during the first buildout.

If the spec ships **UI surfaces** (web, mobile, desktop, or any visual
interface), the first buildout must also produce `docs/design-guidelines.md`
following `docs/playbooks/ui-design-system-contract.md`. The contract file
is a first-class derived artifact alongside product docs — without it,
every page re-invents the visual layer and drift compounds quickly. Stub
the §3 Component Coverage Matrix from day one even if most rows are TODO;
the gap should be visible.

After the specification has been decomposed, do not keep extending it as the
living product plan. Ongoing work should update the smaller product docs,
stories, test matrix, and decision records.

Ongoing work should enter the harness as one of these input types:

- New spec: a project specification that needs to become product docs and
  initial story candidates.
- Spec slice: a selected behavior from the provided spec.
- Change request: a bounded behavior change, bug fix, or product refinement.
- New initiative: a larger product area that needs multiple stories.
- Maintenance request: dependency, architecture, performance, security, or
  operational work.
- Harness improvement: a process, template, proof, or agent-instruction change.

The spec-to-work loop is:

```text
human intent or supplied spec
  -> classify input type
  -> update or create product contract
  -> create story packet or initiative notes when needed
  -> define validation proof
  -> implement or document the blocker
  -> update product docs, stories, test matrix, and decisions
  -> capture harness friction
```

Large product areas should use scoped initiative notes instead of a second
monolithic specification. An initiative should explain the goal, affected
product docs, candidate stories, validation shape, open decisions, and exit
criteria. If initiative work becomes a repeated pattern, add a template or
proposal to `docs/HARNESS_BACKLOG.md`.

## Growth Rule

The harness grows from friction.

When an agent is confused, repeats manual reasoning, needs a new validation
command, discovers a missing rule, or sees a recurring failure pattern, it must
either improve the harness directly or add a proposal to `HARNESS_BACKLOG.md`.

## Future Validation Ladder

No validation scripts exist yet. When implementation begins, the expected ladder
is:

```text
validate:quick
  format, lint, typecheck, unit tests, architecture check

test:integration
  backend, database, provider, or service checks as the stack requires

test:e2e
  user-visible end-to-end flows

test:platform
  shell, mobile, desktop, or deployment smoke checks as the stack requires

test:release
  full suite, log checks, and performance smoke
```

Agents must not claim these commands pass until they exist and have been run.
