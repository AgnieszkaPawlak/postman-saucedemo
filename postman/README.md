# Postman Collection

This directory contains the Postman collection and environment files for the SauceDemo API Testing Suite.

## Files

### SauceDemo_API_Collection.json
The main Postman Collection containing all API test cases organized into logical folders:

- **Authentication**: Login tests with valid/invalid credentials
- **Inventory**: Product listing, details, and search tests
- **Cart**: Shopping cart management operations

**Collection Features:**
- ✅ Postman Collection v2.1 format
- ✅ Pre-request scripts for setup
- ✅ Comprehensive test assertions
- ✅ Response time validation
- ✅ Schema validation
- ✅ Environment variable chaining

### SauceDemo_Environment.json
Environment configuration file containing:
- `base_url`: API base URL (https://dummyjson.com)
- `token`: Authentication token (set dynamically during test execution)
- `product_id`: Sample product ID (set dynamically)

## Using the Collection in Postman

### 1. Import Collection

1. Open Postman Desktop
2. Click **Import** button
3. Select `SauceDemo_API_Collection.json`
4. Click **Import**

### 2. Import Environment

1. Click the **Environments** icon (gear icon)
2. Click **Import**
3. Select `SauceDemo_Environment.json`
4. Select the imported environment from dropdown

### 3. Run Tests

**Run Entire Collection:**
1. Right-click on the collection name
2. Select **Run collection**
3. Configure iterations and delays if needed
4. Click **Run SauceDemo API Testing**

**Run Individual Request:**
1. Select a request from the collection
2. Click **Send**
3. View response and test results in the response panel

**Run Folder:**
1. Right-click on a folder (e.g., "Authentication")
2. Select **Run folder**

### 4. View Test Results

Test results appear in the **Test Results** tab:
- ✅ Green checkmarks = Passed tests
- ❌ Red X marks = Failed tests
- Response time displayed for each request
- Assertion details shown for debugging

## Collection Structure

```
SauceDemo API Testing
├── Authentication
│   ├── Login - Valid Credentials
│   ├── Login - Invalid Credentials
│   └── Login - Missing Fields
├── Inventory
│   ├── Get All Products
│   ├── Get Single Product - Valid ID
│   ├── Get Single Product - Invalid ID
│   └── Search Products
└── Cart
    ├── Get User Cart
    ├── Add Product to Cart
    ├── Update Cart Product Quantity
    └── Delete Cart
```

## Test Scripts Explained

### Authentication Tests
```javascript
// Validate status code
pm.test('Status code is 200', function() {
    pm.response.to.have.status(200);
});

// Store token for subsequent requests
const responseData = pm.response.json();
if (responseData.token) {
    pm.environment.set('token', responseData.token);
}
```

### Schema Validation Example
```javascript
pm.test('Product has required fields', function() {
    const product = pm.response.json();
    pm.expect(product).to.have.property('id');
    pm.expect(product).to.have.property('title');
    pm.expect(product).to.have.property('price');
    pm.expect(product.price).to.be.a('number');
});
```

### Response Time Validation
```javascript
pm.test('Response time is less than 2000ms', function() {
    pm.expect(pm.response.responseTime).to.be.below(2000);
});
```

## Modifying the Collection

### Adding New Requests

1. Right-click on appropriate folder
2. Select **Add Request**
3. Configure request (method, URL, headers, body)
4. Add test scripts in the **Tests** tab
5. Save the request

### Adding New Tests

In the **Tests** tab of any request, add assertions:

```javascript
// Status code test
pm.test('Status code is 200', function() {
    pm.response.to.have.status(200);
});

// JSON validation
pm.test('Response is JSON', function() {
    pm.response.to.be.json;
});

// Custom validation
pm.test('Custom check', function() {
    const data = pm.response.json();
    pm.expect(data.someField).to.equal('expectedValue');
});
```

### Updating Environment Variables

1. Click the environment dropdown
2. Click the eye icon (Quick Look)
3. Click **Edit** to modify variables
4. Update values as needed
5. Save changes

## Exporting Changes

After modifying the collection:

1. Right-click on collection name
2. Select **Export**
3. Choose **Collection v2.1**
4. Save over existing `SauceDemo_API_Collection.json`

For environment changes:
1. Click environment dropdown
2. Click three dots next to environment name
3. Select **Export**
4. Save over existing `SauceDemo_Environment.json`

## Best Practices

✅ **DO:**
- Keep test scripts focused and clear
- Use descriptive test names
- Validate status codes, content-type, and response structure
- Use environment variables for dynamic data
- Chain requests using saved variables
- Add response time assertions

❌ **DON'T:**
- Hardcode sensitive data in collection
- Skip error handling tests
- Forget to validate response schemas
- Use deprecated Postman syntax
- Create duplicate test logic

## Troubleshooting

### Tests Failing?
- Verify environment is selected (dropdown in top-right)
- Check if `base_url` variable is set correctly
- Ensure previous requests (e.g., Login) ran successfully
- Verify API is accessible and responding

### Token Not Working?
- Run the "Login - Valid Credentials" request first
- Check that token is saved: View environment variables
- Verify Authorization header format: `Bearer {{token}}`

### Response Time Failures?
- API might be slow or under load
- Consider increasing threshold in test script
- Check your network connection

## Additional Resources

- [Postman Learning Center](https://learning.postman.com/)
- [Postman API Documentation](https://www.postman.com/api-documentation/)
- [Writing Tests in Postman](https://learning.postman.com/docs/writing-scripts/test-scripts/)
- [Using Variables](https://learning.postman.com/docs/sending-requests/variables/)

## Support

For issues or questions:
- Check the main [README.md](../README.md)
- Review [API Endpoints documentation](../docs/APIEndpoints.md)
- Open an issue on GitHub