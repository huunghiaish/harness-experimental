# Stage Goals

Per-stage `/goal` condition templates for Claude Code v2.1.139+. Use with the
interactive `/goal <condition>` command or headless `claude -p "/goal …"`.

**Substitute placeholders before pasting:**

- `{date}` → today, `YYYY-MM-DD`
- `{slug}` → project / change-request slug, kebab-case
- `{client}` → client name from intake brief
- `{epic_id}` / `{story_id}` → `EXX`, `US-NNN` etc.
- `{run_id}` → playwright run id or short sha

**MANUAL_CHECKPOINT rule (applies to every goal):** if at any point the work
needs offline human action (signing, design tool, credentials, UAT walk-through),
emit a `MANUAL_CHECKPOINT:` block per `AGENTS.md` § Manual Checkpoint Signaling
and stop the turn without satisfying the goal. The next session resumes the
goal via `--resume` after the human comes back.

**Turn cap:** every goal includes `or stop after N turns regardless` so a
mis-stated condition cannot loop forever. Adjust N per stage complexity.

The hook `.claude/hooks/stage-deliver.sh` looks up the entry whose H2 starts
with `## Stage <N>` after a stage-boundary commit and pushes the matching
`Goal:` block to Telegram as ready-to-paste text.

---

## Stage 2 — Intake brief

Goal:
docs/intake/{date}-intake-brief.md exists with every section from
docs/templates/client-intake-brief.md (locale-vi/ for VN clients) filled
from docs/discovery/* inputs. Decision recorded in § 15: accept / proceed
with conditions / park / decline. STAGE.md Snapshot updated to Current=3.A
(if accepted) and a History row added for stage 2. Stop after 10 turns.

## Stage 3.A — Discovery interview

Goal:
docs/intake/{date}-discovery-summary.md exists, covering 5 personas
(End User, BA, QA, Developer, Operator) × 3 modes (Challenge, Guided,
Explore) with REQ list, decisions log, and open-questions section. Reads
the intake brief and raw docs/discovery/* inputs only. STAGE.md updated
to Current=3.B with History row for 3.A. Stop after 12 turns.

## Stage 3.B — Gap analysis

Goal:
docs/intake/{date}-gap-analysis.md exists with the four-column BA layout
(To-Be / As-Is / Gap (6 categories) / Plan of Action with MoSCoW). For a
greenfield project the As-Is column carries a one-line "greenfield, no
As-Is" note; To-Be and Plan of Action must still be filled. STAGE.md
updated to Current=4 with History row for 3.B. Emit MANUAL_CHECKPOINT
asking the client to review before SOW. Stop after 10 turns.

## Stage 4 — Proposal & SOW

Goal:
A SOW file (docs/intake/{date}-sow-{client}.md or
docs/templates/locale-vi/proposal-sow.md rendered) exists with all critical
sections complete: § 4 in-scope (Must + selected Should from Plan of Action),
§ 5 out-of-scope (Could + Won't + reason), § 7 milestones, § 8 payment
schedule, § 9 change-request policy, § 10 acceptance conditions. STAGE.md
updated to Current=5 (only after signed SOW + deposit confirmed by human;
otherwise stop with MANUAL_CHECKPOINT requesting signature). Stop after
8 turns.

## Stage 5 — Spec + Design intake (Phase 1)

Goal:
docs/intake/{date}-spec-intake.md exists per docs/templates/spec-intake.md,
restating the aggregate of docs/discovery/* + docs/intake/* + signed SOW
faithfully (no new derivations yet). Open questions and assumptions logged
explicitly. Emit MANUAL_CHECKPOINT asking the human for Phase 2 approval
before deriving product docs. STAGE.md unchanged (still Current=5).
Stop after 10 turns.

## Stage 5 — Spec + Design intake (Phase 2)

Goal:
Phase 1 spec-intake is approved (human reply confirms). Derived artifacts
exist: docs/product/* per template, docs/design-guidelines.md (if UI),
docs/decisions/{date}-design-direction.md (if UI), and
docs/decisions/{date}-stack-selection.md (use docs/templates/decisions/
stack-selection.md). STAGE.md updated to Current=6 with History row for
stage 5. Stop after 15 turns.

## Stage 6 — Visual & Behavioral Modeling (sub-step A)

Goal:
docs/design-guidelines.md exists from stage 5 and its § 3 Component
Coverage Matrix lists every component the planned screens will use
(stubs allowed but no missing rows). If contract missing or coverage
incomplete, generate the missing rows. STAGE.md unchanged. Stop after
6 turns.

## Stage 6 — Visual & Behavioral Modeling (sub-step B, prototype)

Goal:
docs/visuals/prototype/README.md records the tool chosen (Claude Design
https://claude.ai/design preferred; Stitch / Artifacts / v0.dev / pencil.dev
fallbacks), prototype URL, version, freeze date. One HTML or PNG export
per screen exists under docs/visuals/prototype/screens/. Because prototype
generation is offline work, the goal expects to emit MANUAL_CHECKPOINT
with the tool URL and return condition, then stop. Do not satisfy the
goal until the human confirms the prototype is frozen. Stop after 6 turns.

## Stage 6 — Visual & Behavioral Modeling (sub-step C, diagrams)

Goal:
docs/visuals/diagrams/ contains sitemap, at least one user-flow, business
workflow, ERD draft, role-permission-matrix.md, and one status-flow file
per stateful entity (use docs/templates/locale-vi/role-permission-matrix.md
and status-flow.md as shapes). STAGE.md updated to Current=7 with History
row for stage 6. Stop after 12 turns.

## Stage 7 — Story slicing

Goal:
docs/stories/epics/{epic_id}-{slug}/US-NNN-*.md exists for each REQ in the
product contract. Every REQ has at least one SC token decomposed via the
12-dimension scenario-taxonomy-playbook. High-risk stories use the
high-risk-story/ four-file packet. Tokens cited in story body. STAGE.md
updated to Current=8 with History row for stage 7. Stop after 20 turns.

## Stage 8 — Build (per story)

Goal:
{story_id} acceptance criteria all hold: implementation cited each
US-NNN.REQ-MMM or US-NNN.SC-MMM in commit bodies, tests for at least one
SC token per REQ exist and pass, no architecture change without a new
docs/decisions/ entry, no out-of-scope cleanup beyond the story. Closure
commit added with the story exit message. STAGE.md unchanged unless this
is the last story of the stage. Stop after 30 turns or when
MANUAL_CHECKPOINT requests human review of a risky diff.

## Stage 10 — QA + scenarios

Goal:
docs/TEST_MATRIX.md has at least one TC row per US-NNN.REQ-MMM cited in
the current epic, each row links a canonical-e2e test (one journey per
file, ≤ 8 assertions) at the path stated in the row. Field-by-field
verify reports under plans/reports/{slug}-{run_id}.md exist where the
playbook applies, with their .mp4 sibling produced and noted in the
report. STAGE.md updated to Current=11 with History row for stage 10.
Stop after 15 turns.

## Stage 11 — UAT + signoff

Goal:
docs/stories/.../delivery-closure-story/{overview, 01-uat-plan,
02-signoff, 03-client-update}.md all exist. UAT plan TC table ≤ 40 cases,
each citing an SC token. 02-signoff lists REQ coverage and any exclusions
with decision links. 03-client-update message body is drafted ready to
send. Visual conformance gate: state "live matches frozen prototype" or
log drift in change-request-log. Emit MANUAL_CHECKPOINT asking the client
for signoff before clearing. STAGE.md updated to Current=12 only after
signoff confirmed. Stop after 10 turns.

## Stage 12 — Release + client update

Goal:
A release note (docs/templates/release-note.md rendered, locale-vi/ for
VN client) exists with § 7 pre-deploy + § 8 post-deploy smoke + § 9
rollback plan + § 11 client-update message filled. Every released REQ
token appears in the release note; any deferred REQ links to a follow-up
story. STAGE.md updated to Current=13 with History row for stage 12.
Stop after 10 turns.

## Stage 13 — Handover + maintenance

Goal:
docs/stories/.../project-closure-story/{overview, 01-handover-docs,
02-credentials-handover, 03-knowledge-transfer}.md exist. Stage-6
artifacts (prototype URL + diagrams + frozen RPM + status flows) included
in 01-handover-docs.md's read-this-order index. 02-credentials-handover
follows the vault-pointer pattern (no raw secrets). A maintenance proposal
(docs/templates/locale-vi/maintenance-proposal.md) is drafted with Basic
/ Standard / Premium tiers. STAGE.md updated to Current=done with final
History row. Emit MANUAL_CHECKPOINT asking the client to verify every
credential row before clearing. Stop after 10 turns.

---

## Lookup convention for tooling

Hook scripts pick the correct goal by matching the H2 heading whose stage
number follows `## Stage `. Match against the stage token parsed from the
latest commit subject (e.g. `stage-3b` matches `## Stage 3.B`).

For two-phase stages (currently only stage 5) the hook should pick the
**Phase 1** entry on first entry to the stage. The Phase 2 entry is set
manually after human approval — there is no commit between them.
