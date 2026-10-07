import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import cookieParser from "cookie-parser";
import { authenticateToken } from "./middlewares/auth.middleware";
import { corsOptions } from "./config/cors";
import AuthRouter from "./routes/auth.route";

export function createApp() {
  const app = express();

  app.use(cors(corsOptions));
  app.use(helmet());
  app.use(morgan("dev"));
  app.use(cookieParser());
  app.use(express.json());

  
  app.use('/api/v1/auth', AuthRouter);
  
  app.get("/protected-data", authenticateToken, (_req, res) => {
    const username: unknown = res.locals.username;

    if (typeof username !== "string") {
      return res.status(401).json({
        message: "Nincs hitelesített felhasználó",
      });
    }

    res.json({
      message: `Üdv ${username}, sikeresen elérted a védett adatokat!`,
      data: [1, 2, 3, 4, 5],
    });
  });

  return app;
}