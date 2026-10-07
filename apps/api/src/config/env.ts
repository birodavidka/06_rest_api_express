import {config} from 'dotenv';

config({path:`.env.${process.env.NODE_ENV || 'development'}.local`});


export const {
  PORT, NODE_ENV,JWT_SECRET
} = process.env;

export function getPort(): number{
  return Number(PORT) || 3001;
}

export function getJWTSecret(): string{
  if(!JWT_SECRET){
    throw new Error('JWT_SECRET is not defined');
  }
  return JWT_SECRET;
}