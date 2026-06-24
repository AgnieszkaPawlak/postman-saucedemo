
# Superseded: this project now uses Postman CLI with built-in HTML and JUnit reporters instead of Newman/Allure.

# Migration Plan: JUnit → Allure Reports

This document describes how to replace the current JUnit reporting setup with Allure Report in the SauceDemo API Testing project.

---

## Current State

| Component | JUnit setup today |
|-----------|-------------------|
| Newman reporters | `cli`, `html`, `junit` |
| Output file | `newman/reports/junit-report.xml` |
| Local runner | `newman/run-api-tests.sh` |
| CI workflow | `.github/workflows/blank.yml` |
| CI publishing | `EnricoMi/publish-unit-test-result-action@v2` |
| Git ignore | `newman/reports/*.xml` |
| Documentation | `docs/junit-config-instruction.md` |

---

## Target State

| Component | Allure setup after migration |
|-----------|------------------------------|
| Newman reporters | `cli`, `html`, `allure` |
| Raw results | `newman/reports/allure-results/` |
| HTML report (generated) | `newman/reports/allure-report/` |
| CI publishing | Allure HTML artifact + optional GitHub Pages |
| Git ignore | `newman/reports/allure-results/`, `newman/reports/allure-report/` |

---

## Why Migrate?

- **Richer UI** — timelines, request/response details, history-style views, better failure analysis
- **Better grouping** — suites map to Postman folders; steps map to assertions
- **Industry standard** — Allure is widely used in QA portfolios and CI pipelines
- **Extensible metadata** — optional Allure annotations in Postman test scripts (labels, severity, links)

**Trade-off:** Allure requires an extra npm package and a second step (`allure generate`) to produce HTML. JUnit is simpler and integrates natively with GitHub Checks via XML.

---

## Prerequisites

Before starting, ensure you have:

- Node.js 18+ (already used in CI)
- Newman installed (`npm install -g newman newman-reporter-html`)
- Java 8+ **or** Allure CLI via npm (recommended for CI consistency)

---

## Migration Steps

### Phase 1 — Dependencies

**Option A — project-local (recommended):**

Add dev dependencies to `package.json`:

```bash
npm install --save-dev newman newman-reporter-html newman-reporter-allure allure-commandline
```

**Option B — global install (matches current CI style):**

```bash
npm install -g newman newman-reporter-html newman-reporter-allure allure-commandline
```

Remove JUnit from reporters — no package uninstall needed (JUnit is built into Newman).

---

### Phase 2 — Update `newman/run-api-tests.sh`

1. Replace `JUNIT_REPORT_PATH` with Allure paths:

```bash
ALLURE_RESULTS_DIR="$REPORT_DIR/allure-results"
ALLURE_REPORT_DIR="$REPORT_DIR/allure-report"
```

2. Create directories before the run:

```bash
mkdir -p "$ALLURE_RESULTS_DIR"
```

3. Replace Newman reporters and flags:

**Remove:**
```bash
--reporters cli,html,junit
--reporter-junit-export "$JUNIT_REPORT_PATH"
```

**Add:**
```bash
--reporters cli,html,allure
--reporter-allure-resultsDir "$ALLURE_RESULTS_DIR"
```

4. After Newman finishes (pass or fail), generate the HTML report:

```bash
allure generate "$ALLURE_RESULTS_DIR" -o "$ALLURE_REPORT_DIR" --clean
```

5. Update console output to point to `allure-report/index.html` instead of `junit-report.xml`.

---

### Phase 3 — Update GitHub Actions (`.github/workflows/blank.yml`)

#### 3.1 Install step

```yaml
- name: Install Newman and reporters
  run: npm install -g newman newman-reporter-html newman-reporter-allure allure-commandline
```

#### 3.2 Run tests step

Replace JUnit flags with Allure:

```yaml
mkdir -p newman/reports/allure-results
newman run postman/SauceDemo_API_Collection.json \
  --environment postman/SauceDemo_Environment.json \
  --reporters cli,html,allure \
  --reporter-html-export newman/reports/api-test-report.html \
  --reporter-allure-resultsDir newman/reports/allure-results \
  --color on
```

#### 3.3 Generate Allure HTML (new step)

```yaml
- name: Generate Allure report
  if: always()
  run: allure generate newman/reports/allure-results -o newman/reports/allure-report --clean
```

#### 3.4 Remove JUnit publishing step

Delete the entire step:

```yaml
- name: Publish JUnit test results
  uses: EnricoMi/publish-unit-test-result-action@v2
  ...
```

#### 3.5 Update artifact upload

Upload both raw results and generated HTML:

```yaml
- name: Upload Newman reports
  if: always()
  uses: actions/upload-artifact@v4
  with:
    name: newman-api-report
    path: |
      newman/reports/api-test-report.html
      newman/reports/allure-results/
      newman/reports/allure-report/
    if-no-files-found: warn
    retention-days: 30
```

#### 3.6 Permissions cleanup

JUnit check publishing is no longer needed. You can simplify:

```yaml
permissions:
  contents: read
```

Restore `checks: write` and `pull-requests: write` only if you add a separate GitHub Checks integration later.

#### 3.7 Update job summary text

Change references from "JUnit" to "Allure" in the `Add test summary` and `Fail pipeline` steps.

---

### Phase 4 — Update `.gitignore`

**Remove:**
```
newman/reports/*.xml
```

**Add:**
```
newman/reports/allure-results/
newman/reports/allure-report/
```

Keep `newman/reports/*.html` if you still generate the Newman HTML report.

---

### Phase 5 — Documentation

| File | Action |
|------|--------|
| `docs/junit-config-instruction.md` | Archive or replace with `docs/allure-config-instruction.md` |
| `README.md` | Update "Test Reports" section to describe Allure instead of JUnit |
| `docs/migration-to-allure.md` | Mark migration as complete after implementation |

---

### Phase 6 — Optional Enhancements

These are not required for the initial migration but improve the Allure experience:

1. **Allure metadata in Postman tests** — add labels/severity in test scripts:
   ```javascript
   pm.test('Status code is 200', function () {
       allure.label('severity', 'critical');
       pm.response.to.have.status(200);
   });
   ```

2. **GitHub Pages deployment** — publish `allure-report/` on each main-branch run using `peaceiris/actions-gh-pages` or `simple-elf/allure-report-action`.

3. **Remove duplicate Newman HTML reporter** — Allure can replace `newman-reporter-html` if you no longer need the basic HTML report.

4. **Consolidate workflows** — merge `blank.yml` and `api-tests.yml` into a single workflow to avoid duplicate runs.

---

## Files to Change (Checklist)

- [ ] `package.json` — add `newman-reporter-allure`, `allure-commandline` (optional: pin versions)
- [ ] `newman/run-api-tests.sh` — swap junit → allure, add `allure generate`
- [ ] `.github/workflows/blank.yml` — install, run, generate, artifact, remove JUnit action
- [ ] `.github/workflows/api-tests.yml` — update if kept (uses shell script)
- [ ] `.gitignore` — replace `*.xml` with Allure directories
- [ ] `README.md` — report instructions
- [ ] `docs/junit-config-instruction.md` — deprecate or remove

---

## Verification Checklist

### Local

1. Run `./newman/run-api-tests.sh`
2. Confirm `newman/reports/allure-results/` contains JSON/XML result files
3. Confirm `newman/reports/allure-report/index.html` opens in a browser
4. Confirm failed assertions appear with request/response details in Allure UI
5. Confirm `junit-report.xml` is **no longer** generated

### CI

1. Push to `main` or open a PR
2. Workflow completes without the JUnit publish step
3. Artifact `newman-api-report` contains `allure-report/`
4. Download artifact, open `allure-report/index.html` locally
5. Pipeline still fails when Newman tests fail (`continue-on-error` + final fail step)

---

## Rollback Plan

If Allure causes issues, revert in reverse order:

1. Restore `--reporters cli,html,junit` and `--reporter-junit-export`
2. Re-add `Publish JUnit test results` step in workflow
3. Restore `permissions: checks: write, pull-requests: write`
4. Restore `.gitignore` entry for `*.xml`
5. Uninstall `newman-reporter-allure` and `allure-commandline` if added

JUnit is built into Newman, so rollback does not require reinstalling JUnit.

---

## Estimated Effort

| Task | Effort |
|------|--------|
| Update shell script | ~15 min |
| Update GitHub Actions workflow | ~20 min |
| Update `.gitignore` and docs | ~15 min |
| Local + CI verification | ~20 min |
| Optional GitHub Pages setup | ~30 min |

**Total:** ~1–1.5 hours for core migration.

---

## References

- [Allure Report — Newman integration](https://allurereport.org/docs/newman/)
- [newman-reporter-allure on npm](https://www.npmjs.com/package/newman-reporter-allure)
- [allure-commandline on npm](https://www.npmjs.com/package/allure-commandline)
- Current JUnit setup: `docs/junit-config-instruction.md`
