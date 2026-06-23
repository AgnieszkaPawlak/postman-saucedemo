# API Test Strategy

## Overview
This document outlines the strategic approach for API testing of the SauceDemo application using Postman, Newman, and automated CI/CD pipelines.

## Objectives
1. **Validate API Correctness**: Ensure all endpoints return expected responses with proper status codes, headers, and payload structures
2. **Verify Functional Workflows**: Test complete user journeys including authentication, product browsing, and cart management
3. **Ensure API Stability**: Validate response times, error handling, and edge cases to ensure consistent behavior
4. **Enable Continuous Testing**: Automate test execution in CI/CD pipeline to catch regressions early
5. **Provide Independent Validation**: Test API layer independently from UI to isolate backend issues

## Testing Scope

### In-Scope
- **Authentication & Authorization**
  - Valid/invalid login scenarios
  - Token generation and validation
  - Missing credentials handling
  
- **Product Inventory Management**
  - Retrieve all products
  - Fetch individual product details
  - Search product catalog
  - Handle invalid product IDs
  
- **Shopping Cart Operations**
  - View cart contents
  - Add products to cart
  - Update product quantities
  - Remove products/delete cart
  
- **Non-Functional Testing**
  - Response time validation (< 2000ms)
  - Content-Type header verification
  - JSON schema validation
  - Error message consistency

### Out-of-Scope
- Performance/load testing (covered by k6 or JMeter)
- Security penetration testing
- Database-level validation
- UI integration testing

## Test Levels

### 1. Contract Testing
- Validate API responses match expected schemas
- Verify required fields are present and correctly typed
- Ensure backward compatibility

### 2. Functional Testing
- Test CRUD operations for all resources
- Validate business logic and workflows
- Test data persistence and state management

### 3. Negative Testing
- Invalid authentication credentials
- Malformed request payloads
- Non-existent resource IDs
- Missing required fields
- Unauthorized access attempts

### 4. Integration Testing
- Token chaining across requests
- Sequential workflow testing (login → browse → add to cart)
- Environment variable propagation

## Testing Tools & Technologies

| Tool | Purpose | Version |
|------|---------|---------|
| Postman | Collection design and manual testing | Latest |
| Newman | CLI test runner for automation | Latest |
| Newman HTML Reporter | Test result visualization | Latest |
| GitHub Actions | CI/CD automation | v4 |
| DummyJSON API | Mock API backend | N/A |

## Test Data Strategy
- Use consistent test data stored in environment variables
- Leverage dynamic variables for unique test scenarios
- Store authentication tokens for request chaining
- Utilize response data from previous requests (e.g., product IDs)

## Test Execution Strategy

### Local Testing
```bash
# Run full collection
newman run postman/SauceDemo_API_Collection.json \
  -e postman/SauceDemo_Environment.json

# Run with script
./newman/run-api-tests.sh
```

### CI/CD Automation
- Trigger on every push to main branch
- Run on all pull requests
- Generate and archive HTML reports
- Fail build on test failures

## Success Criteria
- ✅ All test assertions pass (100% pass rate)
- ✅ Response times under 2000ms threshold
- ✅ Proper HTTP status codes returned
- ✅ Valid JSON structures in all responses
- ✅ Environment variables correctly propagated
- ✅ HTML reports generated successfully

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| API endpoint changes | High | Version API, maintain changelog |
| Flaky tests due to network | Medium | Add retry logic, timeouts |
| Environment variable issues | Medium | Validate env config before tests |
| Mock API unavailability | High | Use local mock server as fallback |

## Maintenance & Updates
- Review and update tests when API contracts change
- Expand test coverage for new endpoints
- Refactor tests for improved maintainability
- Monitor test execution times and optimize slow tests
- Keep dependencies (Newman, reporters) up to date

## Reporting
- CLI output for immediate feedback
- HTML reports for detailed analysis
- CI/CD artifact storage for historical tracking
- GitHub Actions summary for quick status overview

## Future Enhancements
- Add data-driven testing with CSV/JSON files
- Implement API performance benchmarking
- Add security testing (SQL injection, XSS)
- Create pre-request scripts for test data generation
- Integrate with monitoring/alerting systems