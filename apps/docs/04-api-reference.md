**Project:** ServiceDesk REST API

**Version:** 1.0

**Satus:** Draft

**Last Updated:** 2026-10-09

## 03 - API-reference

## API Endpoints

| Method | Endpoint | Authentication | Description |
|---|---|---|---|
| `POST` | `/api/v1/auth/register` | No | Register a new user |
| `POST` | `/api/v1/auth/login` | No | Log in and receive an access token |
| `POST` | `/api/v1/auth/refresh` | Refresh cookie | Issue a new token pair |
| `GET` | `/protected-data` | Bearer token | Access protected data |

## Register

### Request

```http
POST /api/v1/auth/register
Content-Type: application/json
```

```json
{
  "username": "example-user",
  "password": "secure-password"
}
```

### Response

```json
{
  "message": "Sikeres regisztráció!"
}
```

## Login

### Request

```http
POST /api/v1/auth/login
Content-Type: application/json
```

```json
{
  "username": "example-user",
  "password": "secure-password"
}
```

### Response

The access token is returned in the response body:

```json
{
  "message": "Sikeres bejelentkezés",
  "accessToken": "<jwt-access-token>"
}
```

A seven-day refresh token is also issued as an `HttpOnly` cookie.

## Protected Route

Send the access token in the `Authorization` header:

```http
GET /protected-data
Authorization: Bearer <jwt-access-token>
```

Example response:

```json
{
  "message": "Üdv example-user, sikeresen elérted a védett adatokat!",
  "data": [1, 2, 3, 4, 5]
}
```