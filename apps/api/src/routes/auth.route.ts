import { Router } from "express";
import { register, login, refreshToken } from "../controllers/auth.controller";

const AuthRouter = Router();

AuthRouter.post("/register", register);
AuthRouter.post("/login", login);
AuthRouter.post("/refresh", refreshToken);

export default AuthRouter;