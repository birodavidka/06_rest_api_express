import express, { type CookieOptions} from 'express';
import { randomUUID } from 'node:crypto';
import bcrypt from 'bcrypt';
import jwt,{type JwtPayload}from 'jsonwebtoken';
import { getAccessTokenSecret, getRefreshTokenSecret, NODE_ENV } from '../config/env';
import { users, refreshSessions } from '../data/index';

const REFRESH_TOKEN_TTL_MS = 7 * 24 * 60 * 60 * 1000; // 7 nap milliszekundumban

const refreshCookieBaseOptions: CookieOptions={
    httpOnly: true,
    secure: NODE_ENV === 'production', // Csak HTTPS-en keresztül küldjük a sütit, ha production környezetben vagyunk
    sameSite: 'lax',
    path: '/api/v1/auth'
}
const refreshCookieOptions: CookieOptions = {
    ...refreshCookieBaseOptions,
    maxAge: REFRESH_TOKEN_TTL_MS,
};


export const register = async (req: express.Request, res: express.Response  ) => {
    try {
        const { username, password } = req.body;
        if (
        typeof username !== "string" ||
        username.trim() === "" ||
        typeof password !== "string" ||
        password.length < 8
        ) {
        return res.status(400).json({
            message: "Érvényes felhasználónév és legalább 8 karakteres jelszó szükséges",
        });
        }

        // Ellenőrizzük, létezik-e már a felhasználó
        if (users.find(u => u.username === username)) {
            return res.status(409).json({ message: 'A felhasználónév már foglalt' });
        }

        // Jelszó titkosítása (a 10 a "salt rounds" száma, ami a titkosítás bonyolultságát adja)
        const hashedPassword = await bcrypt.hash(password, 10);

        // Felhasználó mentése az "adatbázisba"
        const id =
    users.length === 0
    ? 1
    : Math.max(...users.map((user) => user.id)) + 1;
        const newUser = { id, username, password: hashedPassword };
        users.push(newUser);

        res.status(201).json({ message: 'Sikeres regisztráció!' });
    } catch (error) {
        res.status(500).json({ message: 'Szerverhiba' });
    }
};


export const login = async (req: express.Request, res: express.Response) => {
    try {
        const { username, password } = req.body;

        // Felhasználó keresése
        const user = users.find(u => u.username === username);
        if (!user) {
            return res.status(401).json({ message: 'Hibás felhasználónév vagy jelszó' });
        }

        // Jelszó összehasonlítása a hashelt verzióval
        const isPasswordValid = await bcrypt.compare(password, user.password);
        if (!isPasswordValid) {
            return res.status(401).json({ message: 'Hibás felhasználónév vagy jelszó' });
        }

        // JWT Token generálása (payload, titkos kulcs, lejárati idő)
        const accessToken = jwt.sign({ id: user.id, username: user.username ,type: 'access' }, getAccessTokenSecret(), { expiresIn: '15m' });
        
        const sessionId = randomUUID();

        const newRefreshToken = jwt.sign(
        {
            id: user.id,
            username: user.username,
            type: "refresh",
        },
        getRefreshTokenSecret(),
        {
            expiresIn: "7d",
            jwtid: sessionId,
        }
        );

        refreshSessions.set(sessionId, {
        userId: user.id,
        expiresAt: Date.now() + REFRESH_TOKEN_TTL_MS,
        });

        res.cookie(
        "refreshToken",
        newRefreshToken,
        { ...refreshCookieBaseOptions, path: '/api/v1/auth/refresh' }
        );

        return res.json({
        message: "Sikeres bejelentkezés",
        accessToken,
        });

    } catch (error) {
        res.status(500).json({ message: 'Szerverhiba' });
    }
};

export const refreshToken = (
    req: express.Request,
    res: express.Response
    ) => {
    const currentRefreshToken: unknown = req.cookies?.refreshToken;

    if (typeof currentRefreshToken !== "string") {
        return res.status(401).json({
        message: "Hiányzó refresh token",
        });
    }

    let decoded: JwtPayload | string;

    try {
        decoded = jwt.verify(
        currentRefreshToken,
        getRefreshTokenSecret(),
        { algorithms: ["HS256"] }
        );
    } catch {
        res.clearCookie("refreshToken", refreshCookieBaseOptions);

        return res.status(403).json({
        message: "Érvénytelen vagy lejárt refresh token",
        });
    }

    if (
        typeof decoded === "string" ||
        decoded.type !== "refresh" ||
        typeof decoded.jti !== "string" ||
        typeof decoded.id !== "number" ||
        typeof decoded.username !== "string"
    ) {
        res.clearCookie("refreshToken", refreshCookieBaseOptions);

        return res.status(403).json({
        message: "Érvénytelen refresh token",
        });
    }

    const session = refreshSessions.get(decoded.jti);

    if (
        !session ||
        session.userId !== decoded.id ||
        session.expiresAt <= Date.now()
    ) {
        refreshSessions.delete(decoded.jti);
        res.clearCookie("refreshToken", refreshCookieBaseOptions);

        return res.status(403).json({
        message: "A refresh session lejárt vagy vissza lett vonva",
        });
    }

    const user = users.find((user) => user.id === session.userId);

    if (!user) {
        refreshSessions.delete(decoded.jti);
        res.clearCookie("refreshToken", refreshCookieBaseOptions);

        return res.status(403).json({
        message: "A felhasználó nem található",
        });
    }

    // A régi refresh session érvénytelenítése
    refreshSessions.delete(decoded.jti);

    // Új access token
    const accessToken = jwt.sign(
        {
        id: user.id,
        username: user.username,
        type: "access",
        },
        getAccessTokenSecret(),
        {
        expiresIn: "15m",
        algorithm: "HS256",
        }
    );

    // Új refresh token és session
    const newSessionId = randomUUID();

    const newRefreshToken = jwt.sign(
        {
        id: user.id,
        username: user.username,
        type: "refresh",
        },
        getRefreshTokenSecret(),
        {
        expiresIn: "7d",
        jwtid: newSessionId,
        algorithm: "HS256",
        }
    );

    refreshSessions.set(newSessionId, {
        userId: user.id,
        expiresAt: Date.now() + REFRESH_TOKEN_TTL_MS,
    });

    res.cookie(
        "refreshToken",
        newRefreshToken,
        refreshCookieOptions
    );

    return res.json({
        message: "Access token sikeresen megújítva",
        accessToken,
    });
    };