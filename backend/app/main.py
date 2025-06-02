from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routes import router
from dotenv import load_dotenv
import os

load_dotenv(dotenv_path=".env")

DATABASE_URL = os.getenv("DATABASE_URL")
SECRET_KEY = os.getenv("SECRET_KEY")

DATABASE_URL = os.getenv("DATABASE_URL")
print(f"Loaded DB URL: {DATABASE_URL}")  # Add this temporarily for debug

if DATABASE_URL is None:
    raise RuntimeError("DATABASE_URL not found in environment")

app = FastAPI()

# Mount all API routes from routes.py
app.include_router(router)

# Enable CORS for all origins (for dev purposes)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/status")
def get_status():
    return {"status": "ok"}
