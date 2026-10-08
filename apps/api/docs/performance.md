# Performance Benchmark

## Test environment

- Date: 2026-10-08
- Runtime: Node.js 26
- Environment: local development machine
- Target: compiled Express API
- Tool: Autocannon
- Duration: 20 seconds
- Endpoint: `GET /protected-data`
- Concurrent connections: 20
- Authentication: missing or invalid access token
- Response status: HTTP 401

## Command

```bash
npx autocannon \
  -c 20 \
  -d 20 \
  -l \
  --renderStatusCodes \
  http://localhost:3001/protected-data