# Discovery Interview Playbook

**Lifecycle:** experimental · **First use:** TBD · **Verified by:** none

> Portable 5-persona × 3-mode interview shape for turning a new spec,
> change request, or brownfield mystery into a REQ list + decisions log
> + open questions list.

## When To Run

- Spec intake **Phase 1** (first buildout from a user-provided spec).
- Change request analysis when the request is ambiguous or under-specified.
- Brownfield onboarding when the code says one thing and the request
  implies another.

Skip when:

- The request is a tiny-lane patch with clear acceptance.
- The decision is already documented and the work is just executing it.
- A previous interview output is still fresh.

## Personas

Five personas cover intent → build → run. Run each at least once.

| Persona | Role | Primary concerns |
| --- | --- | --- |
| End User | Person who interacts with the final surface | Usability, frequency, failure recovery, accessibility |
| BA | Bridge between stakeholder intent and spec | Scope clarity, decision traceability, stakeholder conflict |
| QA | Owner of proof | Acceptance criteria, edge cases, regression surface, test data |
| Developer | Owner of build | Feasibility, integration surface, tech-debt risk, dependency shape |
| Operator | Owner of run | Deploy shape, monitoring, rollback, support load, on-call burden |

Project-specific titles (Product Owner, SRE, Support Engineer) map to the
nearest persona — do not invent new personas inside this playbook.

## Question Modes

Pick mode per question, not per persona. Most sessions interleave all three.

| Mode | Purpose | Signal it captures | Use when |
| --- | --- | --- | --- |
| Challenge | Stress-test stated assumptions | What the prompt got wrong or glossed over | The spec sounds tidy — pressure-test it |
| Guided | Walk through known decision points | Coverage of standard checkpoints | Intake type is familiar; fill the form |
| Explore | Uncover unknown unknowns | Topics the prompt never named | Brownfield or vague prompts |

## Question Bank (Persona × Mode)

3-5 starter questions per cell. Adapt wording; keep the shape.

### End User × Challenge
- What happens when the network drops mid-action?
- Who else might hit this surface that the brief did not name?
- What does the user do if the action fails silently?
### End User × Guided
- What is the most common path through this surface?
- What is the most common error the user hits today?
- How often does the user perform this — daily, monthly, once?
### End User × Explore
- What workaround do users invent when the system blocks them?
- What does the user check before starting this flow?
- What other tool is open in the next tab while doing this?
### BA × Challenge
- Which stakeholder benefits most? Which loses something?
- What in the brief is genuinely new vs. restating today's behavior?
- Where do the stakeholders disagree about scope?
### BA × Guided
- What in-scope items belong in this iteration vs. the next?
- Which decisions are already locked? Which are still open?
- What did the previous similar feature teach us?
### BA × Explore
- What success metric will this be judged by?
- What would cause the stakeholder to cancel this work?
- What unrelated initiative will collide with this in 90 days?
### QA × Challenge
- What proof would make us confident this works in production?
- What edge case will the demo skip?
- What regression surface does this touch?
### QA × Guided
- What test data exists today? What needs fabricating?
- Which test lane covers this — unit, integration, E2E, manual?
- Where does proof live after the story closes?
### QA × Explore
- What state combinations are we not currently exercising?
- What environments differ from production in ways that hide bugs?
- What past incident does this remind you of?
### Developer × Challenge
- What does this break that currently works?
- What dependency are we silently assuming is stable?
- What part is feasibly tested locally vs. only in staging?
### Developer × Guided
- What modules / services does this touch?
- What is the migration / rollout sequence?
- What flag, config, or env var gates the change?
### Developer × Explore
- What internal API surface is missing that would make this trivial?
- What refactor is overdue and would help here?
- What unknowns scare you most?
### Operator × Challenge
- What is the rollback path? Is it ever tested?
- What alert fires when this breaks in production?
- What does the on-call runbook say about this surface today?
### Operator × Guided
- What deploys with this — code, schema, infra, config?
- What capacity, quota, or rate-limit assumption does this rely on?
- Who gets paged when this fails?
### Operator × Explore
- What recurring support ticket would this finally close?
- What manual workaround does Ops run today that we could remove?
- What logs or metrics are missing that we would want during incident?

## Output Shape

Produce three artifacts under the project's intake or story directory.

1. **REQ list** — markdown table.

   | ID | Description (one line) | Source persona | Confidence |
   | --- | --- | --- | --- |
   | REQ-001 | <one-line description> | End User | high |
   | REQ-002 | <one-line description> | QA | medium |

   Composite form `US-NNN.REQ-001` happens when the REQ lands in a
   specific story (see `docs/HARNESS.md` § Traceability Tokens).
   Example citation in a later story: `US-014.REQ-001` proven by
   `US-014.SC-003` and `US-014.TC-007`.

2. **Decisions log** — markdown list. Each entry: decision name + 1-line
   summary + link (even if the file does not exist yet).

   ```markdown
   - **Role hierarchy model.** Flat roles per company (not nested).
     Draft: `docs/decisions/NNNN-flat-roles-per-company.md`.
   ```

3. **Open questions list** — markdown list. Questions the session could
   not resolve. These either enter the next intake pass or
   `docs/HARNESS_BACKLOG.md` if cross-project.

## Stop Condition

End the session when ANY of these holds:

- 2 consecutive challenge-mode questions produce no new information.
- All 5 personas have at least 1 REQ and 1 decisions-log entry.
- The time-box hits (60-90 min for spec intake; 20-30 min for change request).

Continuing past stop produces diminishing returns and risks scope inflation.

## Hand-Off

- **REQ list** → story candidate identification in `docs/stories/epics/`.
  Each surviving REQ becomes `US-NNN.REQ-MMM` inside its story packet.
- **Decisions log** → seed for `docs/decisions/NNNN-*.md` files.
- **Open questions list** → next iteration's intake, or
  `docs/HARNESS_BACKLOG.md` if cross-project.

## Variant Section

(Append a Variant block here when this playbook fails or partially works.
Do not delete the original shape.)

## Related

- `docs/HARNESS.md` § Traceability Tokens — REQ token format.
- `docs/FEATURE_INTAKE.md` § Spec Approval Gate — caller of this playbook.
- `docs/playbooks/scenario-taxonomy-playbook.md` — consumes the REQ list,
  emits SC tokens (`US-NNN.SC-MMM`).
- `docs/playbooks/README.md` § Use Order — how to add a Variant section.
