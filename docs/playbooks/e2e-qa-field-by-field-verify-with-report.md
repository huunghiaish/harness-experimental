# E2E QA-Manual Field-By-Field Verify With Markdown Report

> An E2E spec needs to (a) fill a long form like a real user, (b) on the post-submit detail page **inspect every field individually as a manual QA would**, (c) emit a `correct | incorrect | manual | not-found` matrix as a markdown report dev can hand-off, and (d) leave a slow-paced video usable as a user-guide. PRs that ship `.check()`-based assertions look fine in CI but silently drop form values, and "verify-via-API" checks prove nothing on the recorded screen.

This is the post-fill counterpart to [e2e-recording-user-guide-quality.md](./e2e-recording-user-guide-quality.md). Use that one for the fill / navigation grammar; use this one when the goal is **verify a persisted entity, field by field, with a report dev can act on**.

## Symptoms

- Spec asserts overall page health via `await expect(page.getByRole('heading', { name })).toBeVisible()` plus a couple of toast checks — gives a green CI signal but cannot answer "which of the 30 fields actually round-tripped".
- Asserts on a single concatenated rendered string (`getByText(data.tenDn)`) so the test passes whenever ANY copy of the value lands anywhere in the DOM, missing fields that silently dropped.
- Spec uses `page.getByRole('checkbox').check()` or `input.check()` to toggle React-controlled `CheckboxGroup`-style components — first checkbox in a group "works", second one silently drops out of the submit payload. Visible only after inspecting the post-save chips on the detail page.
- Test uploads a 1×1 PNG placeholder (≤100 bytes base64 buffer) so verification logic can only check that the BE returned a key; the recorded video has no visual signal that the upload actually rendered as an image.
- Test stack returns HTTP 500 on every `POST /presign-upload` because `R2_/MINIO_/S3_` env is unset, but the FE's `if (url.includes('stub')) return ok` fallback silently masks the failure → upload "succeeds" with a fake key → BE persists the key → detail page tries to fetch a non-existent object → broken image on screen but assertion passes anyway.
- After a "verify on detail page" run, the spec fails on a sub-assertion like `getByText('XX', { exact: true })` looking for the initials fallback — because, ironically, now the logo actually uploaded the initials are no longer rendered.
- Dev gets "test failed" but no consolidated report of WHICH fields are wrong vs which are merely unverifiable vs which are known wiring gaps. They re-derive triage every time.
- Route renamed (`/m/ca-nhan` → `/m/cong-ty`) months ago but the verify spec still navigates to the old path, which now serves a different page that happens to share enough text to keep loose assertions green.

## When This Hits

- Any Playwright/Cypress/WDIO suite that started as CI integration tests and later got asked to double as "QA evidence" or "video walkthrough for dev / sales".
- React + React Hook Form forms where checkbox groups own a `string[]` value via parent `setValue` (`react-hook-form`, `formik`, plain `useState`).
- Stacks where the dev environment uses a real object store (R2, S3, MinIO) but the test stack lazily skips configuration.
- Long forms (4-step wizard, 30+ fields) where verifying everything by hand is unrealistic so devs accept a smoke-only spec.
- Codebases under active rename (route, slug, component) where verify specs lag behind product moves.

## Root Cause

Five compounding patterns:

1. **`Locator.check()` ≠ user click on a React controlled input.** Playwright's `.check()` sets `input.checked` via the DOM property, then a fast `dispatchEvent('change')`. React's synthetic event system reconciles its controlled state from the `checked` PROP, not the `checked` DOM property, so the parent `onChange` may not actually run the setter. For a CheckboxGroup whose `toggle` reads stale `value` to compute `next`, the second click in quick succession then writes a state that *omits* the first item. Net effect: 2nd item silently dropped from submit, but spec passes because the test never re-reads the actual array.
2. **Outer-wrapper label trap.** A "Field" component renders `<label class="block"><span>Field Title</span>{children}</label>`. If children include checkbox option pill labels with text like "OptionA", "OptionB", a Playwright lookup like `page.locator('label').filter({ hasText: 'OptionA' }).first()` matches the **outer** Field label (whose `innerText` contains all options as substrings), and `.first()` walks the DOM-order ancestor — clicking near the center of the wrapper hits the wrong pill (or nothing). The fix needs scoping to "labels that directly contain `<input type='checkbox'>`" or to an exact-text match.
3. **Verify reads aggregated DOM, not per-field DOM.** `await expect(page.getByText(value)).toBeVisible()` matches any element whose innerText contains `value`. For a list of 30 fields with shared substrings ("Khác" appears in 3 sections), this masks per-field correctness. Solution: locator scoped per-field (`dt:has-text('Label') + dd`) + an explicit comparator + an explicit per-field status.
4. **No artifact for dev handoff.** A failing CI step shows `expect(...).toEqual([])` and a screenshot. The dev has to re-run the spec themselves to know what is broken. Spec must emit a markdown report (table per section, `correct | incorrect | manual | not-found` columns) and reference it in the test annotation.
5. **Test-stack env drift.** Test infra lacks env that dev infra has (R2, mail backend, search index). Production-shape behavior never gets exercised → upload code path is "tested" but never actually uploads. Once you light up real upload in test stack, downstream assumptions (initials fallback rendering) break — these are real findings worth surfacing, not flakes to suppress.

## Fix

Three deliverables: a **field-catalog**, a **verify+report driver**, and a **per-field inspect overlay**. Spec calls them in that order.

### 1. Field catalog

Declarative array, one row per visible field on the detail page. Keep selector, expected derivation, and classification policy in data, not in code.

```ts
// e2e/fixtures/detail-page-field-catalog.ts
export type FieldKind = 'text' | 'image' | 'chip-list' | 'manual';

export interface FieldProbe {
  label: string;                 // displayed in report + inspect overlay
  section: string;               // groups rows in the report
  kind: FieldKind;
  expected: (data: Form) => string;
  locator: (page: Page, data: Form) => Locator;
  resolve?: (locator: Locator) => Promise<string>;   // custom extractor
  manualOnly?: boolean;          // skip auto-compare, force human verify
  manualNote?: string;           // surfaced in report
}

const dlValue = (label: string) => (page: Page) =>
  page.locator(`dt:has-text("${label}") + dd`).first();
const chipsIn = (sectionHeading: string) => (page: Page) =>
  page
    .locator('div.card')
    .filter({ has: page.locator(`h3:has-text("${sectionHeading}")`) })
    .first()
    .locator('.tag, .pill');

export const PROFILE_FIELDS: FieldProbe[] = [
  { label: 'Tax ID', section: 'Company', kind: 'text',
    expected: (d) => d.mst, locator: (page) => dlValue('MST')(page) },
  { label: 'Markets', section: 'Markets', kind: 'chip-list',
    expected: () => 'Domestic, Direct export, Other',
    locator: (page) => chipsIn('Markets & Customers')(page) },
  { label: 'Logo', section: 'Hero', kind: 'image',
    expected: () => 'Logo background-image visible (color present)',
    locator: (page) => page.getByTestId('logo-preview'),
    manualOnly: true,
    manualNote: 'Verify color X visible vs initials fallback in video.' },
];
```

### 2. Verify-with-report driver

Walks catalog, inspects each field, classifies, writes markdown. Returns rows so the spec can `expect(rows.filter(r => r.status === 'incorrect')).toEqual([])`.

```ts
// e2e/fixtures/detail-page-verify-report.ts
type RowStatus = 'correct' | 'incorrect' | 'manual' | 'not-found';
interface RowResult { section: string; label: string; expected: string;
  actual: string; status: RowStatus; note?: string }

export async function verifyDetailPageWithReport(page: Page, input: {
  data: Form; outPath: string; inspectHoldMs?: number;
}): Promise<{ rows: RowResult[]; outPath: string }> {
  const rows: RowResult[] = [];
  let section = '';
  for (const probe of PROFILE_FIELDS) {
    if (probe.section !== section) {
      section = probe.section;
      await narrate(page, `Section "${section}"`, 2200);
    }
    rows.push(await verifyOne(page, probe, input.data, input.inspectHoldMs ?? 900));
  }
  await writeReport(input.outPath, input.data, rows);
  return { rows, outPath: input.outPath };
}

async function verifyOne(page, probe, data, holdMs): Promise<RowResult> {
  const expected = probe.expected(data);
  const locator = probe.locator(page, data);
  if (!(await locator.count())) {
    await inspectElement(page, locator, {
      label: `${probe.label} → not found`,
      tone: probe.manualOnly ? 'manual' : 'fail', holdMs,
    });
    return { ...row, actual: '(not found)',
      status: probe.manualOnly ? 'manual' : 'not-found', note: probe.manualNote };
  }
  if (probe.manualOnly) {
    await inspectElement(page, locator, { label: `${probe.label} → manual`,
      tone: 'manual', holdMs });
    return { ...row, actual: '(verify via video)', status: 'manual',
      note: probe.manualNote };
  }
  const actual = await readActual(probe, locator);
  const status = matches(expected, actual, probe.kind) ? 'correct' : 'incorrect';
  await inspectElement(page, locator, { label: `${probe.label} → ${status}`,
    tone: status === 'correct' ? 'pass' : 'fail', holdMs });
  return { ...row, actual, status };
}

function matches(expected, actual, kind) {
  const a = actual.replace(/\s+/g, ' ').trim();
  const e = expected.replace(/\s+/g, ' ').trim();
  if (kind === 'chip-list') {
    const aSet = new Set(a.split(',').map((s) => s.trim()).filter(Boolean));
    const eSet = new Set(e.split(',').map((s) => s.trim()).filter(Boolean));
    return aSet.size === eSet.size && [...eSet].every((v) => aSet.has(v));
  }
  return a === e || a.includes(e);
}
```

Report shape (per section):

```markdown
| Field | Expected | Actual | Correct | Incorrect | Manual / Note |
|-------|----------|--------|:-------:|:---------:|---------------|
| MST   | 0314…    | 0314…  |    x    |           |               |
| Markets (chips) | Domestic, Direct export, Other | Domestic, Other |  | x |  |
| Logo  | bg-image color X | (verify via video) |    |     | See ~02:14 |
```

### 3. Per-field inspect overlay (visual)

So the video shows a real "QA inspect" — outline pulse + tone-colored label chip — over each field as it is verified.

```ts
// e2e/fixtures/inspect-focus.ts
const TONE = { pass: '#16a34a', fail: '#dc2626', manual: '#d97706', neutral: '#2563eb' };

export async function inspectElement(page, locator, {label, tone, holdMs}) {
  if (!(await locator.count())) return drawMissingBanner(page, label, TONE[tone], holdMs);
  await locator.first().scrollIntoViewIfNeeded().catch(() => {});
  await page.waitForTimeout(180);
  const box = await locator.first().boundingBox().catch(() => null);
  if (!box) return drawMissingBanner(page, label, TONE[tone], holdMs);
  await page.evaluate(({box, label, color}) => {
    // pointer-events:none + z-index:2147483640 — never blocks subsequent clicks
    // outline div over box with 3px border + matching label chip above it
    ...
  }, { box, label, color: TONE[tone] });
  await page.waitForTimeout(holdMs);
  await clearInspect(page);
}
```

### 4. Click-checkbox helper that actually works

Never use `.check()` for React-controlled inputs. Click the **label**, scoped so the wrapper-label trap doesn't swallow the lookup.

```ts
async function clickCheckbox(page: Page, text: string) {
  // Exact-text label click wins for CheckboxGroup option labels (label text
  // === option name). Substring fallback for ToggleCard (label + description
  // concatenated). NEVER use Locator.check() on React controlled inputs.
  const exactLabel = page.locator('label')
    .filter({ hasText: new RegExp(`^${escapeRegExp(text)}$`) }).first();
  if (await exactLabel.count()) {
    await exactLabel.click({ delay: 30, timeout: 6000 });
    return;
  }
  await page.locator('label').filter({ hasText: text }).first()
    .click({ delay: 30, timeout: 6000 });
}
```

### 5. Real PNG fixtures (visually distinct, no `sharp` dep)

Solid-color PNGs hand-built from `zlib` + crc32. Used for logo / banner / credential so the video shows the upload landing on screen.

```ts
// e2e/fixtures/recording-image-fixtures.ts
import zlib from 'node:zlib';

export const logoPng = () => solidPng(400, 400, [31, 78, 121]);     // blue
export const bannerPng = () => solidPng(1640, 624, [22, 101, 52]);  // green
export const credentialPng = () => solidPng(800, 600, [180, 83, 9]); // amber

function solidPng(w, h, [r, g, b]) {
  // sig + IHDR + IDAT(zlib(filter-byte + scanlines)) + IEND
  // 70-line file, no external deps. See repo for full source.
  ...
}
```

### 6. Spec wiring

```ts
test('Persona X — full registration + verify with report', async ({ page }) => {
  test.setTimeout(600_000);
  const data = buildFullRegistrationData();
  const reportPath = path.resolve(process.cwd(), '..', '..', 'plans', 'reports',
    `verification-${data.runId}.md`);

  await addVisibleCursor(page);
  await page.goto('/registration');
  await fillFullRegistration(page, data);
  await page.getByRole('button', { name: 'Submit' }).click();
  await page.waitForURL(/success/);

  await loginAs(page, 'admin');
  await approvePendingRegistration(page, data);
  await logout(page);
  await loginNewRegistrant(page, data.email);

  await page.goto('/m/cong-ty');
  await page.waitForLoadState('networkidle');
  const { rows, outPath } = await verifyDetailPageWithReport(page, { data, outPath: reportPath });
  const incorrect = rows.filter((r) => r.status === 'incorrect');
  test.info().annotations.push({ type: 'report',
    description: `Report: ${outPath} (correct=${rows.filter(r=>r.status==='correct').length}, incorrect=${incorrect.length})` });
  expect(incorrect, `Field mismatches:\n${incorrect.map(r =>
    `- ${r.label}: expected="${r.expected}" actual="${r.actual}"`).join('\n')}`).toEqual([]);
});
```

### 7. Test-stack env (storage, mail, search) — must mirror dev

If the verify pass touches an asset (uploaded image, sent email, indexed doc) you cannot leave the test stack with the service un-configured and rely on a FE stub fallback. Either:

- Configure the service inside the test docker-compose pointing at the same dev container (works fine when host can reach it — sign with `localhost:9000` even when api container talks via in-network DNS, since sign-time endpoint only constructs the URL string, no actual connection).
- Or split a dedicated test bucket and provision it in the same compose file.

```yaml
# docker-compose.test.yml — api-test service
environment:
  R2_ENDPOINT: http://localhost:9000   # host-visible so presigned URL works from Playwright
  R2_ACCESS_KEY_ID: minioadmin
  R2_SECRET_ACCESS_KEY: minioadmin
  R2_BUCKET: hasi-dev
  R2_PUBLIC_URL: http://localhost:9000/hasi-dev
```

### 8. Tolerant assertions for legitimately-conditional UI

When lighting up real services exposes assertions that were only true under the broken state (e.g. "initials avatar visible" was only true because no logo ever uploaded), wrap them in `.catch(() => {})` rather than deleting — keeps the intent legible:

```ts
await expect(page.getByText(getInitials(name)).first())
  .toBeVisible({ timeout: 1_000 })
  .catch(() => {}); // initials fallback only when no logo uploaded
```

## Spec-vs-product bug discrimination

The verify report **must** discriminate spec bugs from product bugs. Use the `status` taxonomy:

- `correct` — actual matches expected exactly.
- `incorrect` — matched element found, value differs. **Real product bug. Fail the test.**
- `not-found` — element not present at expected selector. **Usually a spec drift** (renamed component, moved section) OR a real rendering bug. Investigate but DO NOT block on it by default.
- `manual` — `manualOnly: true` rows. Surface a `manualNote` explaining what to eyeball in the video. **Never fails the test.**

Spec assertion gates only on `incorrect`. `not-found` produces a yellow-amber row in the report ("element missing — please confirm"). Manual rows produce a checklist at the bottom of the report dev/QA can tick off after watching the video.

## Test-recording cadence config

```ts
// playwright.config.ts — recording project
{
  name: 'personas',
  use: {
    headless: !process.env.E2E_HEADED,
    video: 'on',                              // always record on this project
    viewport: { width: 1280, height: 720 },   // matches video size on YouTube embed
    launchOptions: { slowMo: Number(process.env.E2E_SLOWMO ?? 350) },
  },
},
```

Run with `E2E_RECORD=1 E2E_SLOWMO=350` for video; with `E2E_SLOWMO=0` for fast CI smoke.

## Handoff artifact list

Every successful run leaves:

- `plans/reports/verification-<runId>.md` — auto-generated, one per run.
- `plans/reports/<persona>-<runId>.webm` — copied from `test-results/.../video.webm` so artifacts live alongside the report (dev clicks one folder).
- `plans/reports/<persona>-handoff.md` — hand-written summary linking the above + listing P0/P1/P2 findings (wiring gaps, env drift, route renames the auto-report cannot detect).

## One-shot `/goal` prompt template (preferred)

Default to this single self-driving prompt instead of splitting work across two sessions (QA pass first → wait for human review → dev fix second). The agent reads the playbook, upgrades the spec, runs the test, and on failure either fixes the spec itself OR spawns a dev sub-agent with the handoff prompt (see next section) and re-runs — all in one go until the acceptance gate passes.

Use the older "two-step" workflow only when the product change is risky enough to need a human review checkpoint between QA report and code fix.

```
/goal '<absolute-path-to-spec.ts>'

# <Feature/Persona> — Complete end-to-end

Final target: feature DONE 100%, user-guide-quality video, verify report has
ZERO incorrect + ZERO unexplained not-found, manual rows only for fields a
human must eyeball (uploaded image rendering, animation, layout).

## Sequence

### Step 1 — Read playbook + prior art
- ~/harness-experimental/docs/playbooks/e2e-qa-field-by-field-verify-with-report.md
- ~/harness-experimental/docs/playbooks/e2e-recording-user-guide-quality.md
- Any prior persona/feature spec that already uses this pattern (link by path)
  + its handoff doc, so you can mirror the catalog / verify driver / report.

### Step 2 — Upgrade the spec
- Switch to the correct verify route if renamed.
- Convert form fill to per-keystroke `pressSequentially` + real PNG uploads
  via the colored-fixtures helper (build new colors if more upload kinds).
- Extend the field catalog to cover EVERY field the form writes. Fields the
  form can't change → `manualOnly: true` with a note saying why.
- Wire cursor overlay + slowScroll. Reuse the label-click `clickCheckbox` —
  NEVER `Locator.check()` (silently drops React-controlled CheckboxGroup values).
- Report path: `plans/reports/<feature>-<HHMM>-verification-<runId>.md`.

### Step 3 — Run + fix-loop (max 3 iterations)
```
cd <app-dir> && E2E_RECORD=1 E2E_SLOWMO=350 \
  pnpm exec playwright test --project=<recording-project> <spec-path>
```
On failure, classify the root cause:
- **Spec bug** (wrong locator, stale catalog, fill race) → fix spec/helper,
  re-run. No dev hand-off needed.
- **Product/wiring bug** (incorrect row from round-trip data loss, not-found
  from adapter hardcode, route drift) → spawn a sub-agent with the Dev
  handoff prompt template (next section), instruct it to fix the P0 items,
  wait for completion, then re-run the spec.
- Append each iteration's "correct vs manual vs incorrect" diff to the
  handoff doc so the PR reviewer sees the trajectory.
- After 3 fix iterations without reaching the acceptance gate, STOP and
  escalate to the human with the remaining findings. Do NOT weaken
  assertions to force green.

### Step 4 — Acceptance gate
Exit the loop ONLY when ALL hold:
1. Spec passes 3 consecutive runs (real flakes will surface).
2. Final report: 0 incorrect, 0 unexplained not-found (each remaining
   not-found has a `manualNote` explaining why).
3. Manual rows are genuinely human-eyeball-only (image rendering, animation,
   layout) — NOT a stand-in for "wiring gap I gave up fixing".
4. Video plays comfortably at 1×, subtitles sync action, cursor visible,
   no 404 / empty states / dev jargon.
5. Handoff doc lists every P0/P1/P2 (resolved + outstanding) so reviewer
   has full context.

### Step 5 — Ship
- Copy final `.webm` to `plans/reports/<feature>-<runId>.webm` (do not commit
  if `*.webm` is gitignored; reference path in PR body instead).
- Open PR from feature branch → integration branch (check `git log` to see
  the project's convention). Title ≤ 70 chars. Body sections: `## Summary`
  (3 bullets), `## Test plan` (run command + expected counts), `## Findings
  for follow-up` (link the handoff doc).
- Merge if CI is green.

## Constraints (do not break)
- NEVER `Locator.check()` for React-controlled checkboxes. Always label click.
- NEVER paraphrase findings into the handoff doc — quote artifact paths.
- NEVER weaken `expect(incorrect).toEqual([])` to force pass. Fix the cause.
- NEVER commit `.webm` if gitignored (copy elsewhere or reference in PR).
- NEVER touch helpers/specs marked stable in prior PRs.
- NEVER `--no-verify`, `--amend`, force-push.

## Done definition
`git log <integration-branch>` shows the new commit merged, latest verify
report shows 0 incorrect + 0 unexplained not-found, video usable as tutorial.
```

Fill placeholders: `<absolute-path-to-spec.ts>`, `<Feature/Persona>`, `<app-dir>`, `<recording-project>`, `<feature>` slug, `<integration-branch>`. Anything else (file paths in spec, catalog field count, etc.) the agent derives from reading the spec.

### Why one-shot beats two-step

| Aspect | Two-step (QA → wait → dev) | One-shot `/goal` |
|--------|----------------------------|------------------|
| Wall clock | Hours-days (human in the loop twice) | Minutes-1 hour (single agent loop) |
| Context loss between QA + fix | High (different session, re-derive findings) | None (same agent holds report + fix context) |
| Risk of weakening assertions | Lower (human reviews report) | Mitigated by the 3-iteration cap + "do not weaken" constraint |
| Handoff doc fidelity | Hand-written, can drift from report | Auto-quoted + appended per iteration |
| When to prefer two-step | Risky product change, multi-team, regulated diff | (rare) |

Default to one-shot. Only fall back to two-step when the product change touches money flow, auth, schema migration, or any other "must have human approval" boundary.

## Dev handoff prompt template

Used INSIDE the one-shot `/goal` flow (Step 3 → "Product/wiring bug" branch) when the agent spawns a fix sub-agent, or standalone for the two-step variant. Keep it short, link to artifacts (don't paraphrase findings), state precise file + line targets, and define acceptance criteria the dev can verify by re-running the spec.

```
# <Persona/Feature> — Fix findings from E2E QA verify

Branch: <branch>
Repo: <repo-root>
Spec passes but has manual/not-found rows. Fix the items below so the next
verify run promotes them to correct.

## Read first (don't skip)

1. plans/reports/<persona>-handoff.md      — P0/P1/P2 with rationale.
2. plans/reports/verification-<runId>.md   — 34-row matrix expected vs actual.
3. plans/reports/<persona>-<runId>.webm    — UI behaviour for manual rows.

## Tasks (priority order)

### P0 — <short title>
File: <exact/path:line>
Current: <one-liner of the bug>
Required: <bullet steps; minimal scope>
Done when: <which report row(s) flip from manual/not-found → correct>

### P1 — <short title>
File: <exact/path:line>
Required: <bullet steps>
Done when: <observable signal>

### P2 — <short title>
…

## Acceptance criteria

1. P0: re-run `<exact pnpm/yarn command>`, the new report at
   plans/reports/verification-<NEW>.md shows row X as correct.
2. P1: written decision in docs/<file>.md; full persona suite green.
3. P2: …

## Do not touch

- Spec <path> + fixtures <list> — currently stable.
- `<helper>` — current behaviour intentional; reverting breaks <reason>.

## PR review checklist

- Before/after diff of correct vs manual counts in report summary.
- One screenshot proving the fix on screen.
- No new spec failures in `<personas suite name>`.
```

Rules for the prompt:

- **Quote artifact paths, do not summarise findings inline.** The dev re-reads the report; you cannot keep the prompt and the report in sync as the report regenerates every run.
- **Always cite file paths with line numbers.** Vague pointers ("the adapter file") cost the dev a search round-trip.
- **Define "done" per task with a single observable signal** — usually a specific report row's status flipping. Avoid "tests pass" alone; that is necessary but not sufficient.
- **Spell out what NOT to touch.** Otherwise the dev will helpfully revert a label-click fix to `.check()` and reintroduce the dropped-checkbox bug.
- **Keep the prompt copy-pasteable.** No prose, no apology, no "thanks". The dev's agent will inline-quote it; junk increases the chance of misread directives.

## Acceptance gate

Before declaring "done":

1. Spec passes 3 consecutive runs (no flakes).
2. Report shows zero `incorrect` rows; any `not-found` rows have a written explanation.
3. Video playback at 1× speed is comfortable to follow without pausing.
4. A dev with no context can read the handoff + open the video and reproduce/fix every P0 finding in under 30 minutes.

If any of those fails, fix the spec / catalog rather than weakening the assertions.

## Related Tools And Skills

- [e2e-recording-user-guide-quality.md](./e2e-recording-user-guide-quality.md) — fill / navigation grammar, narrate-pin-after, visible cursor overlay.
- [headless-browser-blank-screenshot.md](./headless-browser-blank-screenshot.md) — when the video itself is blank.
- `/ck:web-testing` — Playwright wrapper with project / slowMo defaults.
- `/ck:ai-multimodal` — Gemini Vision audit on the produced `.webm` if you want an automated gate on video quality.
- `/ck:chrome-devtools` — manual single-spec debugging when one row stays `not-found`.

## History

- `2026-05-17`: created. Discovered while upgrading `persona 02 — đăng ký mới` on the HASI monorepo to (a) fill every form field including logo/banner/credential uploads, (b) verify each field on `/m/cong-ty` with a markdown report, (c) record a slow video as user-guide, and (d) hand off P0/P1/P2 findings to dev. Took 8 spec iterations to land green; root causes: `Locator.check()` silently dropping React-controlled CheckboxGroup values (2 sub-bugs masked by lenient `getByText` assertions), `Field` wrapper label trap on substring lookups, test stack missing R2 env (presign 500 masked by FE stub fallback), tolerant-assertion regressions when real upload lit up. Final spec: 34 verified fields, 29 correct / 0 incorrect / 5 manual / 0 not-found, 3.6m runtime headless, video 8MB.
