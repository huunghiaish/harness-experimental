# Discovery Inputs

Raw input artifacts received from clients or external sources during discovery and across the project lifecycle: source documents, meeting notes, screenshots, sample data, change-request raw messages, third-party references, voice-memo transcripts.

This folder holds **inputs**. Derived artifacts (vendor-produced briefs, REQ lists, decision docs, story packets) live elsewhere:

- `docs/intake/*.md` — vendor-produced intake briefs and discovery summaries.
- `docs/product/*.md` — current product contract derived from inputs.
- `docs/stories/*.md` — story packets derived from inputs.
- `docs/decisions/*.md` — decisions citing inputs.

## Naming Convention

```text
YYYY-MM-DD-{kebab-slug}.{ext}
```

Date = when the artifact was received or recorded, NOT when it was filed.

Examples:

- `2026-05-17-client-kickoff-meeting-notes.md`
- `2026-05-18-checkout-mockup-screenshot.png`
- `2026-05-20-change-request-raw-email.md`
- `2026-05-22-sample-orders-export.csv`
- `2026-05-24-competitor-flow-screen-recording.mp4`

Multiple artifacts on the same day: append a disambiguator suffix.

- `2026-05-17-client-meeting-notes-part-1.md`
- `2026-05-17-client-meeting-notes-part-2.md`

## Structure

Flat by default. Sub-folders emerge from friction, not from upfront planning.

Promote to sub-folders when EITHER holds:

- A cluster of 10+ files share the same artifact type (e.g. lots of screenshots).
- Binary files (images, videos, PDFs) noticeably crowd markdown grep results.

When promoting, retain the date-prefix naming inside the sub-folder.

## Lifecycle

**Append-only.** Inputs are immutable after they enter the folder. If a meeting was re-summarized, that is a new dated file, not an edit of the original.

If an input becomes obsolete (e.g. client changed mind on a feature), do not delete — annotate the supersession in a new file or in the citing decision.

## Linking

Cite inputs by relative path from the citing document:

- From a story: `Input: docs/discovery/2026-05-17-client-meeting-notes.md § 3`.
- From a decision: `Source: docs/discovery/2026-05-20-change-request-raw-email.md`.
- From an intake brief: `Discovery call captured at docs/discovery/2026-05-17-discovery-call-notes.md`.

A `grep -r docs/discovery/2026-05-17` should surface every downstream artifact that traced back to that day's inputs.

## Sensitive Content

**No raw secrets. No PII. No credentials.**

- If a meeting transcript captures a customer name + email + DOB, redact before filing.
- If a screenshot shows the client's production credentials, crop or blur before filing.
- If the input itself is sensitive in full (e.g. legal contract draft), store in the org's secret vault and file a pointer here:

```markdown
# 2026-05-20-master-services-agreement (pointer)

Stored in <vault path>. Access via <SSO group>. Not duplicated here.

Cited from:
- docs/decisions/0009-master-services-agreement.md
```

## Index

Add `INDEX.md` only when the file count makes the directory listing unhelpful (~25+ files). The file-name grep + date prefix is the default audit mechanism.

## Cross-Reference

- `docs/playbooks/discovery-interview-playbook.md` — the canonical interview shape that produces inputs filed here.
- `docs/playbooks/solo-dev-client-delivery.md` § Stage 2-3 — uses inputs from this folder.
- `docs/HARNESS_BACKLOG.md` entry "Standard file-naming convention for discovery artifacts (B1)" — origin of the convention.
- `docs/decisions/0009-discovery-input-folder-convention.md` — adoption decision.
