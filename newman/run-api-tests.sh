#!/bin/bash

#########################################
# Newman API Test Runner Script
# Purpose: Execute Postman collection tests via Newman CLI
# Outputs: CLI results + HTML report
#########################################

# Exit on any error
set -e

# Define script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Define paths relative to project root
COLLECTION_PATH="$PROJECT_ROOT/postman/SauceDemo_API_Collection.json"
ENVIRONMENT_PATH="$PROJECT_ROOT/postman/SauceDemo_Environment.json"
REPORT_DIR="$SCRIPT_DIR/reports"
REPORT_PATH="$REPORT_DIR/api-test-report.html"

# Ensure report directory exists
mkdir -p "$REPORT_DIR"

# Print configuration
echo "========================================"
echo "Newman API Test Execution"
echo "========================================"
echo "Collection: $COLLECTION_PATH"
echo "Environment: $ENVIRONMENT_PATH"
echo "Report: $REPORT_PATH"
echo "========================================"
echo ""

# Execute Newman with error handling
echo "Running API tests..."
if newman run "$COLLECTION_PATH" \
  -e "$ENVIRONMENT_PATH" \
  --reporters cli,html \
  --reporter-html-export "$REPORT_PATH" \
  --color on \
  --bail; then
  echo ""
  echo "✅ All tests passed!"
  echo "📊 HTML Report: $REPORT_PATH"
  exit 0
else
  EXIT_CODE=$?
  echo ""
  echo "❌ Tests failed with exit code: $EXIT_CODE"
  echo "📊 HTML Report: $REPORT_PATH"
  exit $EXIT_CODE
fi