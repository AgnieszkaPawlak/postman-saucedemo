#!/bin/bash

#########################################
# Postman CLI API Test Runner Script
# Purpose: Execute Postman collection tests via Postman CLI
# Outputs: CLI results + HTML + JUnit reports
#########################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

COLLECTION_PATH="$PROJECT_ROOT/postman/SauceDemo_API_Collection.json"
ENVIRONMENT_PATH="$PROJECT_ROOT/postman/SauceDemo_Environment.json"
REPORT_DIR="$SCRIPT_DIR/reports"
HTML_REPORT_PATH="$REPORT_DIR/api-test-report.html"
JUNIT_REPORT_PATH="$REPORT_DIR/junit-report.xml"

mkdir -p "$REPORT_DIR"

if [ -x "$PROJECT_ROOT/node_modules/.bin/postman" ]; then
  POSTMAN="$PROJECT_ROOT/node_modules/.bin/postman"
else
  POSTMAN="postman"
fi

echo "========================================"
echo "Postman CLI API Test Execution"
echo "========================================"
echo "Collection: $COLLECTION_PATH"
echo "Environment: $ENVIRONMENT_PATH"
echo "HTML report: $HTML_REPORT_PATH"
echo "JUnit report: $JUNIT_REPORT_PATH"
echo "========================================"
echo ""

echo "Running API tests..."
set +e
"$POSTMAN" collection run "$COLLECTION_PATH" \
  -e "$ENVIRONMENT_PATH" \
  --reporters cli,html,junit \
  --reporter-html-export "$HTML_REPORT_PATH" \
  --reporter-junit-export "$JUNIT_REPORT_PATH" \
  --reporter-html-omitAllHeadersAndBody \
  --color on \
  --bail
POSTMAN_EXIT=$?
set -e

if [ "$POSTMAN_EXIT" -eq 0 ]; then
  echo ""
  echo "All tests passed!"
  echo "HTML Report: $HTML_REPORT_PATH"
  echo "JUnit Report: $JUNIT_REPORT_PATH"
  exit 0
else
  echo ""
  echo "Tests failed with exit code: $POSTMAN_EXIT"
  echo "HTML Report: $HTML_REPORT_PATH"
  echo "JUnit Report: $JUNIT_REPORT_PATH"
  exit "$POSTMAN_EXIT"
fi
