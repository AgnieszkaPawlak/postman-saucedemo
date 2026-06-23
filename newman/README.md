# Newman Test Runner

This directory contains the Newman CLI test runner script and generated test reports.

## Overview

Newman is a command-line collection runner for Postman. It allows you to run and test Postman Collections directly from the command line, making it perfect for:
- Local development testing
- CI/CD pipeline integration
- Automated regression testing
- Scheduled test execution

## Files

### run-api-tests.sh
Bash script that executes the Postman collection using Newman with proper configuration:

**Features:**
- ✅ Automatic path resolution (works from any directory)
- ✅ Error handling with proper exit codes
- ✅ CLI output for immediate feedback
- ✅ HTML report generation
- ✅ Report directory auto-creation
- ✅ Informative execution logging

### reports/
Directory where HTML test reports are generated after each test run.

**Report Features:**
- Summary of test execution
- Pass/fail status for each test
- Request/response details
- Response times
- Visual charts and statistics

## Running Tests Locally

### Prerequisites

Ensure Newman is installed:

```bash
npm install -g newman newman-reporter-html
```

Verify installation:

```bash
newman --version
```

### Method 1: Using the Script (Recommended)

```bash
# From project root
./newman/run-api-tests.sh
```

**First time setup:**
```bash
chmod +x newman/run-api-tests.sh
```

### Method 2: Direct Newman Command

```bash
# From project root
newman run postman/SauceDemo_API_Collection.json \
  -e postman/SauceDemo_Environment.json \
  --reporters cli,html \
  --reporter-html-export newman/reports/api-test-report.html
```

### Method 3: From Newman Directory

```bash
cd newman
./run-api-tests.sh
```

The script automatically handles path resolution!

## Command Options

### Basic Execution
```bash
newman run <collection> -e <environment>
```

### With HTML Report
```bash
newman run <collection> \
  -e <environment> \
  --reporters cli,html \
  --reporter-html-export <path>
```

### Additional Options
```bash
# Run with verbose output
newman run <collection> -e <environment> --verbose

# Stop on first failure
newman run <collection> -e <environment> --bail

# Set timeout (milliseconds)
newman run <collection> -e <environment> --timeout 10000

# Disable colored output
newman run <collection> -e <environment> --no-color

# Run with delay between requests (ms)
newman run <collection> -e <environment> --delay-request 1000

# Run specific folder
newman run <collection> -e <environment> --folder "Authentication"

# Set custom iteration data
newman run <collection> -e <environment> -d data.json
```

## Understanding the Output

### CLI Output

```bash
┌─────────────────────────┬─────────────┬──────────────┐
│                         │   executed  │     failed   │
├─────────────────────────┼─────────────┼──────────────┤
│             iterations  │          1  │           0  │
├─────────────────────────┼─────────────┼──────────────┤
│               requests  │         11  │           0  │
├─────────────────────────┼─────────────┼──────────────┤
│           test-scripts  │         22  │           0  │
├─────────────────────────┼─────────────┼──────────────┤
│       prerequest-scripts│          0  │           0  │
├─────────────────────────┼─────────────┼──────────────┤
│             assertions  │         33  │           0  │
└─────────────────────────┴─────────────┴──────────────┘
```

**Key Metrics:**
- **iterations**: Number of collection runs (default: 1)
- **requests**: Total API requests executed
- **test-scripts**: Test scripts run
- **assertions**: Individual test assertions checked
- **failed**: Count of failures (should be 0 ✅)

### HTML Report

Open the generated report:
```bash
open newman/reports/api-test-report.html
```

**Report Sections:**
1. **Summary**: Overall pass/fail statistics
2. **Requests**: Detailed list of all executed requests
3. **Tests**: Individual test results with assertions
4. **Response**: Full request/response data for debugging

## Exit Codes

The script exits with standard codes for CI/CD integration:

- `0` = All tests passed ✅
- `1` = One or more tests failed ❌

This enables proper CI/CD pipeline failure handling.

## CI/CD Integration

### GitHub Actions

The project includes a GitHub Actions workflow that uses this script:

```yaml
- name: Run API Tests
  run: ./newman/run-api-tests.sh
```

Full workflow: [`.github/workflows/api-tests.yml`](../.github/workflows/api-tests.yml)

### Jenkins

```groovy
stage('API Tests') {
    steps {
        sh './newman/run-api-tests.sh'
    }
}
```

### GitLab CI

```yaml
test:
  script:
    - npm install -g newman newman-reporter-html
    - ./newman/run-api-tests.sh
  artifacts:
    paths:
      - newman/reports/
```

## Troubleshooting

### Script Permission Denied
```bash
chmod +x newman/run-api-tests.sh
```

### Newman Not Found
```bash
npm install -g newman newman-reporter-html
```

### Collection Not Found
Ensure you're running from project root or the script will auto-resolve paths.

### Tests Failing
1. Check HTML report for details: `newman/reports/api-test-report.html`
2. Verify API endpoint is accessible
3. Check environment variables are set correctly
4. Run individual requests in Postman to debug

### HTML Report Not Generated
- Ensure `newman-reporter-html` is installed
- Check write permissions for `newman/reports/` directory
- Verify no disk space issues

## Advanced Usage

### Custom Environment Variables

Override environment variables at runtime:

```bash
newman run postman/SauceDemo_API_Collection.json \
  -e postman/SauceDemo_Environment.json \
  --env-var "base_url=https://custom-api.com"
```

### Multiple Iterations

Run the collection multiple times:

```bash
newman run postman/SauceDemo_API_Collection.json \
  -e postman/SauceDemo_Environment.json \
  -n 5
```

### Data-Driven Testing

Use external CSV or JSON data:

```bash
newman run postman/SauceDemo_API_Collection.json \
  -e postman/SauceDemo_Environment.json \
  -d test-data.json
```

### Custom Reporters

Add additional reporters:

```bash
newman run postman/SauceDemo_API_Collection.json \
  -e postman/SauceDemo_Environment.json \
  --reporters cli,html,json,junit
```

## Report Retention

- **Local**: Reports stored indefinitely in `newman/reports/`
- **CI/CD**: GitHub Actions retains artifacts for 30 days

Consider implementing report archiving for long-term storage:

```bash
# Archive with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
cp newman/reports/api-test-report.html \
   newman/reports/archive/report_${TIMESTAMP}.html
```

## Performance Tips

### Parallel Execution

For faster execution with multiple collections:

```bash
# Using GNU parallel
parallel newman run ::: collection1.json collection2.json
```

### Reduce Delays

If tests are slow:
- Check response time thresholds in test scripts
- Optimize API endpoint performance
- Use local mock servers for faster testing

## Additional Resources

- [Newman Documentation](https://github.com/postmanlabs/newman)
- [Newman Command Options](https://learning.postman.com/docs/running-collections/using-newman-cli/command-line-integration-with-newman/)
- [HTML Reporter](https://www.npmjs.com/package/newman-reporter-html)
- [CI/CD Integration Guide](https://learning.postman.com/docs/running-collections/using-newman-cli/integration-with-ci-cd/)

## Support

For issues or questions:
- Check the main [README.md](../README.md)
- Review [Test Strategy documentation](../docs/TestStrategy.md)
- Open an issue on GitHub