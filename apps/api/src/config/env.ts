import {config} from 'dotenv';

config({path:`.env.${process.env.NODE_ENV || 'development'}.local`});


export const {
  PORT, NODE_ENV,JWT_ACCESS_SECRET,JWT_REFRESH_SECRET
} = process.env;

export function getPort(): number{
  return Number(PORT) || 3001;
}

/* export function getJWTSecret(): string{
  if(!JWT_SECRET){
    throw new Error('JWT_SECRET is not defined');
  }
  return JWT_SECRET;
} */

export function getAccessTokenSecret(): string{
  if(!JWT_ACCESS_SECRET){
    throw new Error('JWT_ACCESS_SECRET is not defined');
  }
  return JWT_ACCESS_SECRET;
}

export function getRefreshTokenSecret(): string{
  if(!JWT_REFRESH_SECRET){
    throw new Error('JWT_REFRESH_SECRET is not defined');
  }
  return JWT_REFRESH_SECRET;
}