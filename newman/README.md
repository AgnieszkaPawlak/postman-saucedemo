# Postman CLI Test Runner

This directory contains the Postman CLI test runner script and generated test reports.

## Overview

The [Postman CLI](https://learning.postman.com/docs/postman-cli/postman-cli-overview/) is Postman's official command-line tool for running Postman collections. It supports:

- Local development testing from exported JSON files
- CI/CD pipeline integration
- Built-in HTML and JUnit reporters (no extra npm plugins)
- Automated regression testing

## Files

### run-api-tests.sh

Bash script that executes the Postman collection using Postman CLI:

**Features:**
- Automatic path resolution (works from any directory)
- Error handling with proper exit codes
- CLI output for immediate feedback
- HTML and JUnit report generation
- Report directory auto-creation
- Informative execution logging

### reports/

Directory where HTML and JUnit test reports are generated after each test run.

## Running Tests Locally

### Prerequisites

Install dependencies from the project root:

```bash
npm install
```

Or install Postman CLI globally:

```bash
npm install -g postman-cli
```

Verify installation:

```bash
postman --version
```

### Method 1: Using npm script (Recommended)

```bash
npm run test:api
```

### Method 2: Using the script directly

```bash
# From project root
chmod +x newman/run-api-tests.sh
./newman/run-api-tests.sh
```

### Method 3: Direct Postman CLI command

```bash
postman collection run postman/SauceDemo_API_Collection.json \
  -e postman/SauceDemo_Environment.json \
  --reporters cli,html,junit \
  --reporter-html-export newman/reports/api-test-report.html \
  --reporter-junit-export newman/reports/junit-report.xml \
  --color on \
  --bail
```

## Command Options

### Basic execution

```bash
postman collection run <collection> -e <environment>
```

### With reports

```bash
postman collection run <collection> \
  -e <environment> \
  --reporters cli,html,junit \
  --reporter-html-export newman/reports/api-test-report.html \
  --reporter-junit-export newman/reports/junit-report.xml
```

### Additional options

```bash
# Stop on first failure
postman collection run <collection> -e <environment> --bail

# Set timeout (milliseconds)
postman collection run <collection> -e <environment> --timeout 10000

# Control colored output
postman collection run <collection> -e <environment> --color on

# Run specific folder
postman collection run <collection> -e <environment> --folder "Authentication"

# Override environment variables
postman collection run <collection> -e <environment> --env-var "base_url=https://custom-api.com"
```

## Reports

| Reporter | Output | Purpose |
|----------|--------|---------|
| `cli` | Terminal | CI logs, immediate feedback |
| `html` | `api-test-report.html` | Human-readable report with request/test details |
| `junit` | `junit-report.xml` | CI integrations (GitHub Checks, Jenkins, etc.) |

Open the HTML report:

```bash
open newman/reports/api-test-report.html
```

## Exit Codes

- `0` = All tests passed
- Non-zero = One or more tests failed

## CI/CD Integration

GitHub Actions runs this script via `npm ci` and `./newman/run-api-tests.sh`.

Full workflow: [`.github/workflows/api-tests.yml`](../.github/workflows/api-tests.yml)

### GitLab CI example

```yaml
test:
  script:
    - npm ci
    - ./newman/run-api-tests.sh
  artifacts:
    paths:
      - newman/reports/
```

## Troubleshooting

### Script permission denied

```bash
chmod +x newman/run-api-tests.sh
```

### Postman CLI not found

```bash
npm install
# or
npm install -g postman-cli
```

### HTML or JUnit report not generated

- Ensure `newman/reports/` exists and is writable
- Check that reporters are specified: `--reporters cli,html,junit`

## Additional Resources

- [Postman CLI overview](https://learning.postman.com/docs/postman-cli/postman-cli-overview/)
- [Run a collection](https://learning.postman.com/docs/postman-cli/postman-cli-run-collection/)
- [Reporters](https://learning.postman.com/docs/postman-cli/postman-cli-reporters/)
- [GitHub Actions integration](https://learning.postman.com/docs/postman-cli/postman-cli-github-actions/)
