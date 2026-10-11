**Project:** ServiceDesk REST API

**Version:** 1.0

**Satus:** Draft

**Last Updated:** 2026-10-11


## 01 - auth-handling

## Authentication Flow

1. The user registers with a username and password.
2. The password is hashed with bcrypt.
3. After login, the API returns a short-lived access token.
4. A longer-lived refresh token is stored in an `HttpOnly` cookie.
5. The access token is sent in the `Authorization` header.
6. When the access token expires, the refresh endpoint creates a new token pair.
7. Refresh token rotation invalidates the previously used refresh session.