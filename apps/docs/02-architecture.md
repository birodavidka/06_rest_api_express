**Project:** ServiceDesk REST API

**Version:** 1.0

**Satus:** Draft

**Last Updated:** 2026-10-11


## 01 - Architecture

### Project Structure

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
