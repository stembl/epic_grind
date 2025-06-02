from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import Optional
from .models import User
from .db import get_db
from .utils import hash_password, verify_password

router = APIRouter()

# Pydantic model used for all user input
class UserIn(BaseModel):
    email: str
    password: Optional[str] = None
    name: Optional[str] = ""
    race: Optional[str] = ""
    role: Optional[str] = ""

class XPUpdate(BaseModel):
    email: str
    amount: int

@router.post("/register")
def register(user: UserIn, db: Session = Depends(get_db)):
    if db.query(User).filter(User.email == user.email).first():
        raise HTTPException(status_code=400, detail="User already exists")
    db_user = User(
        email=user.email,
        password_hash=hash_password(user.password),
        name=user.name,
        race=user.race,
        role=user.role,
        xp=0,
    )
    db.add(db_user)
    db.commit()
    return {"message": "Account created"}

@router.post("/login")
def login(user: UserIn, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.email == user.email).first()
    if not db_user or not verify_password(user.password, db_user.password_hash):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    return {
        "message": "Login successful",
        "user": {
            "email": db_user.email,
            "name": db_user.name,
            "race": db_user.race,
            "role": db_user.role,
            "xp": db_user.xp
        }
    }

@router.patch("/character")
def update_character(user: UserIn, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.email == user.email).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    db_user.name = user.name
    db_user.race = user.race
    db_user.role = user.role
    db.commit()
    return {"message": "Character updated"}

@router.get("/character")
def get_character(email: str, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.email == email).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    return {
        "email": db_user.email,
        "name": db_user.name,
        "race": db_user.race,
        "role": db_user.role,
        "xp": db_user.xp
    }

@router.post("/xp")
def update_xp(xp_update: XPUpdate, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.email == xp_update.email).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    db_user.xp += xp_update.amount
    db.commit()
    return {"message": "XP updated", "new_xp": db_user.xp}

@router.post("/analytics")
def log_analytics(event: dict):
    print("Analytics Event:", event)
    return {"message": "Analytics received"}
