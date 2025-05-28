from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routes import router
from dotenv import load_dotenv
import os

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
SECRET_KEY = os.getenv("SECRET_KEY")

app = FastAPI()

# Enable CORS for all origins (for dev purposes)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount all API routes from routes.py
app.include_router(router)

@app.get("/status")
def get_status():
    return {"status": "ok"}
