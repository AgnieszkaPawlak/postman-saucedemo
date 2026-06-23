#!/bin/bash

#########################################
# Newman API Test Runner Script
# Purpose: Execute Postman collection tests via Newman CLI
# Outputs: CLI results + HTML + Allure reports
#########################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

COLLECTION_PATH="$PROJECT_ROOT/postman/SauceDemo_API_Collection.json"
ENVIRONMENT_PATH="$PROJECT_ROOT/postman/SauceDemo_Environment.json"
REPORT_DIR="$SCRIPT_DIR/reports"
HTML_REPORT_PATH="$REPORT_DIR/api-test-report.html"
ALLURE_RESULTS_DIR="$REPORT_DIR/allure-results"
ALLURE_REPORT_DIR="$REPORT_DIR/allure-report"

mkdir -p "$REPORT_DIR" "$ALLURE_RESULTS_DIR"

if [ -x "$PROJECT_ROOT/node_modules/.bin/newman" ]; then
  NEWMAN="$PROJECT_ROOT/node_modules/.bin/newman"
  ALLURE="$PROJECT_ROOT/node_modules/.bin/allure"
else
  NEWMAN="newman"
  ALLURE="allure"
fi

echo "========================================"
echo "Newman API Test Execution"
echo "========================================"
echo "Collection: $COLLECTION_PATH"
echo "Environment: $ENVIRONMENT_PATH"
echo "HTML report: $HTML_REPORT_PATH"
echo "Allure results: $ALLURE_RESULTS_DIR"
echo "Allure report: $ALLURE_REPORT_DIR"
echo "========================================"
echo ""

echo "Running API tests..."
set +e
"$NEWMAN" run "$COLLECTION_PATH" \
  -e "$ENVIRONMENT_PATH" \
  --reporters cli,html,allure \
  --reporter-html-export "$HTML_REPORT_PATH" \
  --reporter-allure-resultsDir "$ALLURE_RESULTS_DIR" \
  --color on \
  --bail
NEWMAN_EXIT=$?
set -e

if [ -d "$ALLURE_RESULTS_DIR" ] && [ "$(ls -A "$ALLURE_RESULTS_DIR" 2>/dev/null)" ]; then
  echo ""
  echo "Generating Allure report..."
  "$ALLURE" generate "$ALLURE_RESULTS_DIR" -o "$ALLURE_REPORT_DIR" --clean
else
  echo ""
  echo "No Allure results found; skipping report generation."
fi

if [ "$NEWMAN_EXIT" -eq 0 ]; then
  echo ""
  echo "All tests passed!"
  echo "HTML Report: $HTML_REPORT_PATH"
  echo "Allure Report: $ALLURE_REPORT_DIR/index.html"
  exit 0
else
  echo ""
  echo "Tests failed with exit code: $NEWMAN_EXIT"
  echo "HTML Report: $HTML_REPORT_PATH"
  echo "Allure Report: $ALLURE_REPORT_DIR/index.html"
  exit "$NEWMAN_EXIT"
fi
