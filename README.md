# Express REST API with JWT Authentication

A TypeScript-based REST API built with Express. The project demonstrates user registration, password hashing, JWT authentication, protected routes, and refresh-token-based session handling.

## Features

- User registration
- Password hashing with bcrypt
- User login
- Short-lived JWT access tokens
- Refresh tokens stored in `HttpOnly` cookies
- Separate secrets for access and refresh tokens
- Server-side refresh session tracking
- Protected routes
- Request logging with Morgan
- Security headers with Helmet
- CORS configuration
- TypeScript support

## Authentication Status

- ✅ Registration
- ✅ Login
- ✅ Access token generation
- ✅ Protected routes
- ✅ Refresh token generation
- ✅ Refresh token stored in an `HttpOnly` cookie
- ✅ Refresh token verification and rotation
- 🚧 Logout and session revocation

## Tech Stack

- Node.js
- Express 5
- TypeScript
- JSON Web Token
- bcrypt
- cookie-parser
- Helmet
- CORS
- Morgan
- Turborepo

## Project Structure

```text
apps/api/
├── src/
│   ├── config/
│   │   ├── cors.ts
│   │   └── env.ts
│   ├── controllers/
│   │   └── auth.controller.ts
│   ├── data/
│   │   └── index.ts
│   ├── middlewares/
│   │   └── auth.middleware.ts
│   ├── routes/
│   │   └── auth.route.ts
│   ├── app.ts
│   ├── index.ts
│   └── server.ts
├── package.json
└── tsconfig.json
```

## Requirements

- Node.js 24 or newer
- npm 11 or newer

## Installation

Clone the repository and install the dependencies:

```bash
git clone <repository-url>
cd 06_rest_api_express
npm install
```

## Environment Variables

Create this file:

```text
apps/api/.env.development.local
```

Add the following variables:

```env
PORT=3001
JWT_ACCESS_SECRET=your-long-random-access-secret
JWT_REFRESH_SECRET=your-long-random-refresh-secret
```

Generate secure random secrets with:

```bash
openssl rand -base64 48
```

Run the command twice and use a different value for each secret.

Never commit environment files or real secrets to version control.

## Development

Start the API in development mode:

```bash
npm run dev --workspace=api
```

The server will be available at:

```text
http://localhost:3001
```

## Build

Compile the TypeScript source:

```bash
npm run build --workspace=api
```

Run the compiled application:

```bash
npm run start --workspace=api
```

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

## Authentication Flow

1. The user registers with a username and password.
2. The password is hashed with bcrypt.
3. After login, the API returns a short-lived access token.
4. A longer-lived refresh token is stored in an `HttpOnly` cookie.
5. The access token is sent in the `Authorization` header.
6. When the access token expires, the refresh endpoint creates a new token pair.
7. Refresh token rotation invalidates the previously used refresh session.

## Security

- Passwords are never stored as plain text.
- Access and refresh tokens use different secrets.
- Refresh tokens are not exposed to browser JavaScript.
- Refresh cookies use `HttpOnly` and `SameSite=Lax`.
- Production cookies use the `Secure` attribute.
- Refresh sessions can be revoked on the server.
- Helmet adds common HTTP security headers.

## Current Limitations

This project currently uses in-memory storage:

- Users are lost when the server restarts.
- Refresh sessions are lost when the server restarts.
- The application is intended for learning and demonstration purposes.
- A production application should use a database and Redis or another persistent session store.

## Roadmap

- [ ] Complete refresh token rotation
- [ ] Add logout and session revocation
- [ ] Add request validation with Zod
- [ ] Add a persistent database
- [ ] Store refresh sessions in Redis or a database
- [ ] Add rate limiting
- [ ] Add automated tests
- [ ] Add centralized error handling


## Performance

Local load testing was performed with Autocannon against the compiled
production build.

| Metric | Result |
|---|---:|
| Average throughput | 31,252 requests/sec |
| Total requests | 625,037 |
| Average latency | 0.02 ms |
| p99 latency | <1 ms |
| p99.9 latency | 3 ms |
| Maximum latency | 27 ms |

> This benchmark measured the unauthorized authentication-rejection path.
> All requests returned HTTP 401, so the results do not represent successful
> authenticated requests or production network conditions.

![Autocannon benchmark summary](docs/assets/autocannon-summary.png)

[View the detailed benchmark report](docs/performance.md)

## License

This project is licensed under the ISC License.

