import express from 'express';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { getAccessTokenSecret } from '../config/env';
import { users } from '../data/index';


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
        const accessToken = jwt.sign({ id: user.id, username: user.username }, getAccessTokenSecret(), { expiresIn: '15m' });

        res.json({ message: 'Sikeres bejelentkezés', accessToken });
    } catch (error) {
        res.status(500).json({ message: 'Szerverhiba' });
    }
};

export const refreshToken = async (req: express.Request,res: express.Response) => {
    try {
        const refreshToken = req.body;
        console.log('Refresh token endpoint called');
    } catch (error) {
        res.status(500).json({ message: 'Szerverhiba' });
    }
};