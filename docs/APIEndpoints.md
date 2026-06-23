# API Endpoints Reference

## Base URL
```
https://dummyjson.com
```

## Authentication Endpoints

### Login - POST `/auth/login`

**Description**: Authenticate user and receive access token

**Request Body**:
```json
{
  "username": "string",
  "password": "string"
}
```

**Success Response** (200 OK):
```json
{
  "id": 1,
  "username": "string",
  "email": "string",
  "firstName": "string",
  "lastName": "string",
  "gender": "string",
  "image": "string",
  "token": "string"
}
```

**Error Response** (400/401):
```json
{
  "message": "Invalid credentials"
}
```

**Test Scenarios**:
- ✅ Valid credentials → 200 OK with token
- ✅ Invalid credentials → 400/401 with error message
- ✅ Missing password field → 400/422 validation error

---

## Product/Inventory Endpoints

### Get All Products - GET `/products`

**Description**: Retrieve paginated list of all products

**Query Parameters**:
- `limit` (optional): Number of items per page (default: 30)
- `skip` (optional): Number of items to skip (default: 0)

**Success Response** (200 OK):
```json
{
  "products": [
    {
      "id": 1,
      "title": "string",
      "description": "string",
      "price": 549,
      "discountPercentage": 12.96,
      "rating": 4.69,
      "stock": 94,
      "brand": "string",
      "category": "string",
      "thumbnail": "string",
      "images": ["string"]
    }
  ],
  "total": 100,
  "skip": 0,
  "limit": 30
}
```

**Test Scenarios**:
- ✅ Retrieve all products → 200 OK with products array
- ✅ Validate product schema
- ✅ Response time < 2000ms

---

### Get Single Product - GET `/products/{id}`

**Description**: Retrieve details of a specific product by ID

**Path Parameters**:
- `id` (required): Product ID (integer)

**Success Response** (200 OK):
```json
{
  "id": 1,
  "title": "string",
  "description": "string",
  "price": 549,
  "discountPercentage": 12.96,
  "rating": 4.69,
  "stock": 94,
  "brand": "string",
  "category": "string",
  "thumbnail": "string",
  "images": ["string"]
}
```

**Error Response** (404 Not Found):
```json
{
  "message": "Product with id '{id}' not found"
}
```

**Test Scenarios**:
- ✅ Valid product ID → 200 OK with product details
- ✅ Invalid product ID → 404 Not Found
- ✅ Validate all required fields present

---

### Search Products - GET `/products/search`

**Description**: Search products by query string

**Query Parameters**:
- `q` (required): Search query string

**Success Response** (200 OK):
```json
{
  "products": [
    {
      "id": 1,
      "title": "string",
      "description": "string",
      "price": 549
    }
  ],
  "total": 4,
  "skip": 0,
  "limit": 30
}
```

**Test Scenarios**:
- ✅ Search with valid query → 200 OK with matching products
- ✅ Validate response structure
- ✅ Response time < 2000ms

---

## Cart Endpoints

### Get User Cart - GET `/carts/{id}`

**Description**: Retrieve cart contents for a specific user

**Path Parameters**:
- `id` (required): Cart/User ID (integer)

**Headers**:
```
Authorization: Bearer {token}
```

**Success Response** (200 OK):
```json
{
  "id": 1,
  "products": [
    {
      "id": 1,
      "title": "string",
      "price": 549,
      "quantity": 1,
      "total": 549,
      "discountPercentage": 12.96,
      "discountedPrice": 477.41
    }
  ],
  "total": 2328,
  "discountedTotal": 1941,
  "userId": 1,
  "totalProducts": 5,
  "totalQuantity": 10
}
```

**Test Scenarios**:
- ✅ Get cart with valid ID → 200 OK with cart details
- ✅ Validate cart schema and products array
- ✅ Verify authorization header required

---

### Add Product to Cart - POST `/carts/add`

**Description**: Add a product to user's cart

**Headers**:
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body**:
```json
{
  "userId": 1,
  "products": [
    {
      "id": 1,
      "quantity": 1
    }
  ]
}
```

**Success Response** (200 OK):
```json
{
  "id": 1,
  "products": [
    {
      "id": 1,
      "title": "string",
      "price": 549,
      "quantity": 1,
      "total": 549
    }
  ],
  "total": 549,
  "discountedTotal": 477,
  "userId": 1,
  "totalProducts": 1,
  "totalQuantity": 1
}
```

**Test Scenarios**:
- ✅ Add product to cart → 200 OK with updated cart
- ✅ Validate product added to products array
- ✅ Verify total calculated correctly

---

### Update Cart - PUT `/carts/{id}`

**Description**: Update product quantities in cart

**Path Parameters**:
- `id` (required): Cart ID (integer)

**Headers**:
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body**:
```json
{
  "merge": false,
  "products": [
    {
      "id": 1,
      "quantity": 3
    }
  ]
}
```

**Success Response** (200 OK):
```json
{
  "id": 1,
  "products": [
    {
      "id": 1,
      "title": "string",
      "price": 549,
      "quantity": 3,
      "total": 1647
    }
  ],
  "total": 1647,
  "discountedTotal": 1433,
  "userId": 1,
  "totalProducts": 1,
  "totalQuantity": 3
}
```

**Test Scenarios**:
- ✅ Update quantity → 200 OK with updated totals
- ✅ Validate quantity reflected correctly
- ✅ Verify total recalculated

---

### Delete Cart - DELETE `/carts/{id}`

**Description**: Delete a cart

**Path Parameters**:
- `id` (required): Cart ID (integer)

**Headers**:
```
Authorization: Bearer {token}
```

**Success Response** (200 OK):
```json
{
  "id": 1,
  "products": [],
  "total": 0,
  "discountedTotal": 0,
  "userId": 1,
  "totalProducts": 0,
  "totalQuantity": 0,
  "isDeleted": true,
  "deletedOn": "2023-11-15T10:30:00.000Z"
}
```

**Test Scenarios**:
- ✅ Delete cart → 200 OK with deletion confirmation
- ✅ Validate isDeleted flag is true
- ✅ Response time < 2000ms

---

## Common Response Headers

All successful API responses include:
```
Content-Type: application/json; charset=utf-8
Access-Control-Allow-Origin: *
```

## HTTP Status Codes

| Code | Description | Usage |
|------|-------------|-------|
| 200 | OK | Successful GET, PUT, DELETE |
| 201 | Created | Successful POST (resource created) |
| 400 | Bad Request | Invalid request body/parameters |
| 401 | Unauthorized | Invalid/missing authentication |
| 404 | Not Found | Resource doesn't exist |
| 422 | Unprocessable Entity | Validation error |
| 500 | Internal Server Error | Server-side error |

## Authentication

Most endpoints (except `/auth/login`) require authentication via Bearer token:

```
Authorization: Bearer {token}
```

Tokens are obtained from the `/auth/login` endpoint and stored in the environment variable `{{token}}` for subsequent requests.

## Rate Limiting

DummyJSON API has rate limiting. If exceeded:
- Status: 429 Too Many Requests
- Retry after the specified time in response headers

## Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `base_url` | API base URL | `https://dummyjson.com` |
| `token` | Auth token from login | `eyJhbGciOiJIUzI1NiIsInR5...` |
| `product_id` | Sample product ID | `1` |