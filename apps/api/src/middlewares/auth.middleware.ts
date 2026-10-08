import { NextFunction,Request,Response } from "express";
import {getAccessTokenSecret} from "../config/env";
import jwt from "jsonwebtoken";



export const authenticateToken = (req:Request, res: Response, next: NextFunction) => {
    // A token az Authorization headerben érkezik: "Bearer <token>"
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ message: 'A hozzáférés megtagadva, token hiányzik' });
    }

    // Token ellenőrzése
jwt.verify(token, getAccessTokenSecret(), (err, decoded) => {
    if (
        err ||
        !decoded ||
        typeof decoded === "string" ||
        typeof decoded.username !== "string"
    ) {
    return res
        .status(403)
        .json({ message: "Érvénytelen vagy lejárt token" });
    }

    res.locals.username = decoded.username;

    next();
});
};