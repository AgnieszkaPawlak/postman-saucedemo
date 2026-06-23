# API Test Plan

## Document Information

| Field | Value |
|-------|-------|
| **Project** | SauceDemo API Testing |
| **Version** | 1.0 |
| **Last Updated** | November 2025 |
| **Status** | Active |

## 1. Introduction

### 1.1 Purpose
This test plan outlines the approach, resources, and schedule for testing the SauceDemo API. It defines the scope of testing, test methodologies, test deliverables, and success criteria.

### 1.2 Project Overview
The SauceDemo API Testing project validates the REST API endpoints for an e-commerce application, covering authentication, product inventory management, and shopping cart operations using Postman collections and automated Newman execution.

### 1.3 Audience
- QA Engineers
- Development Team
- DevOps Engineers
- Project Stakeholders

## 2. Test Scope

### 2.1 In-Scope

#### Authentication Module
- ✅ POST `/auth/login` - Valid credentials
- ✅ POST `/auth/login` - Invalid credentials
- ✅ POST `/auth/login` - Missing required fields
- ✅ Token generation and storage
- ✅ Token usage in subsequent requests

#### Inventory Module
- ✅ GET `/products` - Retrieve all products
- ✅ GET `/products/:id` - Get single product (valid ID)
- ✅ GET `/products/:id` - Handle invalid product ID
- ✅ GET `/products/search` - Search products by query
- ✅ Product schema validation
- ✅ Authorization header validation

#### Cart Module
- ✅ GET `/carts/:id` - View cart contents
- ✅ POST `/carts/add` - Add product to cart
- ✅ PUT `/carts/:id` - Update cart quantities
- ✅ DELETE `/carts/:id` - Delete cart
- ✅ Cart data structure validation

#### Cross-Cutting Concerns
- ✅ HTTP status code validation
- ✅ Content-Type header verification
- ✅ Response time performance checks (< 2000ms)
- ✅ JSON schema validation
- ✅ Error message consistency
- ✅ Environment variable propagation

### 2.2 Out-of-Scope
- ❌ UI/Frontend testing
- ❌ Database direct validation
- ❌ Load/stress testing (covered separately)
- ❌ Security penetration testing
- ❌ Mobile API-specific testing
- ❌ Third-party integrations

## 3. Test Approach

### 3.1 Test Types

#### Functional Testing
Validate that each endpoint performs its intended function with correct inputs and produces expected outputs.

#### Negative Testing
Test API behavior with invalid inputs, unauthorized access, and edge cases to ensure proper error handling.

#### Integration Testing
Verify that multiple API endpoints work together correctly in sequential workflows (e.g., login → browse → add to cart).

#### Contract Testing
Ensure API responses conform to expected schemas and data types, maintaining backward compatibility.

### 3.2 Test Execution Methods

| Method | Tool | Frequency |
|--------|------|-----------|
| Manual Testing | Postman UI | During development |
| Automated Testing | Newman CLI | On-demand locally |
| CI/CD Testing | GitHub Actions | Every commit/PR |
| Regression Testing | Newman CLI | Before releases |

### 3.3 Test Data Management
- Environment variables stored in `SauceDemo_Environment.json`
- Base URL configurable for different environments
- Dynamic token storage from authentication responses
- Product IDs captured from API responses for chaining

## 4. Test Environment

### 4.1 API Endpoint
- **Base URL**: `https://dummyjson.com`
- **Protocol**: HTTPS
- **Format**: JSON

### 4.2 Tools & Versions

| Tool | Version | Purpose |
|------|---------|---------|
| Postman | Latest | Collection design & manual testing |
| Newman | Latest | CLI automation |
| newman-reporter-html | Latest | HTML report generation |
| Node.js | 20.x | Runtime environment |
| GitHub Actions | v4 | CI/CD automation |

## 5. Test Deliverables

### 5.1 Test Artifacts
- ✅ Postman Collection (`SauceDemo_API_Collection.json`)
- ✅ Environment Configuration (`SauceDemo_Environment.json`)
- ✅ Newman Runner Script (`run-api-tests.sh`)
- ✅ CI/CD Pipeline Configuration (`.github/workflows/api-tests.yml`)
- ✅ Test Documentation (this document)
- ✅ HTML Test Reports (generated per execution)

### 5.2 Test Reports
- **CLI Output**: Real-time console feedback during execution
- **HTML Report**: Detailed test results with request/response data
- **GitHub Actions Summary**: Pass/fail status in CI pipeline
- **Artifacts**: Archived reports accessible for 30 days

## 6. Test Execution Schedule

| Phase | Activity | Timeline |
|-------|----------|----------|
| Planning | Define test scope and strategy | Week 1 |
| Design | Create Postman collections | Week 1-2 |
| Development | Write test scripts and assertions | Week 2 |
| Execution | Run tests locally and validate | Week 2-3 |
| Automation | Configure CI/CD pipeline | Week 3 |
| Maintenance | Ongoing test updates | Continuous |

## 7. Entry & Exit Criteria

### 7.1 Entry Criteria
- ✅ API endpoints are deployed and accessible
- ✅ Environment configuration is complete
- ✅ Postman collection is created
- ✅ Test data is prepared
- ✅ Newman is installed locally and in CI

### 7.2 Exit Criteria
- ✅ All test cases executed successfully (100% pass rate)
- ✅ No critical/blocking defects remain open
- ✅ HTML reports generated without errors
- ✅ CI/CD pipeline running successfully
- ✅ Test documentation is complete
- ✅ Code review and approval obtained

## 8. Test Metrics

### 8.1 Key Performance Indicators

| Metric | Target | Current Status |
|--------|--------|----------------|
| Test Pass Rate | 100% | ✅ Target Met |
| Test Coverage | All endpoints | ✅ Complete |
| Response Time | < 2000ms | ✅ Within SLA |
| Test Execution Time | < 5 minutes | ✅ Optimal |
| CI Build Success | > 95% | ✅ Stable |

### 8.2 Tracked Metrics
- Total test cases: 11
- Passed tests: Track per execution
- Failed tests: Track per execution
- Average response time: Monitor trends
- Test execution duration: Optimize as needed

## 9. Risks & Mitigation

| Risk | Probability | Impact | Mitigation Strategy |
|------|------------|--------|---------------------|
| API endpoint unavailable | Low | High | Use health check before tests, implement retry logic |
| Environment variable issues | Medium | Medium | Validate configuration before execution |
| Flaky network tests | Medium | Low | Add timeout handling, retry mechanisms |
| Test data conflicts | Low | Medium | Use isolated test accounts, clean up after tests |
| CI/CD pipeline failures | Low | High | Implement robust error handling, notifications |

## 10. Responsibilities

| Role | Responsibilities |
|------|------------------|
| **QA Lead** | Test strategy, plan approval, final sign-off |
| **QA Engineer** | Collection design, test script development, execution |
| **DevOps Engineer** | CI/CD setup, pipeline maintenance, environment management |
| **Developer** | API stability, defect fixes, API documentation |

## 11. Approval

| Role | Name | Signature | Date |
|------|------|-----------|------|
| QA Lead | [Name] | _________ | __/__/__ |
| Project Manager | [Name] | _________ | __/__/__ |
| Development Lead | [Name] | _________ | __/__/__ |

---

**Document Version Control**

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | Nov 2025 | QA Team | Initial test plan creation |