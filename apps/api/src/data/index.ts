export type RefreshSession ={
  userId: number,
  expiresAt: number
}

export const refreshSessions = new Map<string, RefreshSession>()

export const users = [
  { id: 1, username: 'testuser', password: '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36ZQ5F5j6G5F5j6G5F5j6G' }, // hashed password for 'password123'
  { id: 2, username: 'johndoe', password: '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36ZQ5F5j6G5F5j6G5F5j6G' } // hashed password for 'mypassword'
]