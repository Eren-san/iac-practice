import os
import hashlib
import mysql.connector
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

class UserAction(BaseModel):
    username: str
    password: str


def get_db_connection():
    try:
        return mysql.connector.connect(
            host=os.getenv("DB_HOST"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD"),
            database="db" 
        )
    except Exception as e:
        print(f"{e}")
        return None


@app.on_event("startup")
def setup_database():
    conn = get_db_connection()
    if conn:
        cursor = conn.cursor()
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS users (
                id INT AUTO_INCREMENT PRIMARY KEY,
                username VARCHAR(50) UNIQUE NOT NULL,
                password_hash VARCHAR(255) NOT NULL
            )
        """)
        conn.commit()
        cursor.close()
        conn.close()


@app.post("/register")
def register(user: UserAction):

    h = hashlib.sha256(user.password.encode()).hexdigest()
    
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Veritabanına bağlanılamadı")
    
    try:
        cursor = conn.cursor()
        cursor.execute("INSERT INTO users (username, password_hash) VALUES (%s, %s)", (user.username, h))
        conn.commit()
        return {"status": "success", "message": f"{user.username} başarıyla kaydedildi."}
    finally:
        cursor.close()
        conn.close()


@app.post("/login")
def login(user: UserAction):
    h = hashlib.sha256(user.password.encode()).hexdigest()
    
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Veritabanına bağlanılamadı")
        
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE username = %s AND password_hash = %s", (user.username, h))
    result = cursor.fetchone()
    
    cursor.close()
    conn.close()

    if result:
        return {"status": "success", "message": f"Hoş geldin {user.username}!"}
    else:
        raise HTTPException(status_code=401, detail="Hatalı kullanıcı adı veya şifre!")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=80)