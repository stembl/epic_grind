from sqlalchemy import Column, String, Integer
from .db import Base

class User(Base):
    __tablename__ = "users"

    email = Column(String, primary_key=True, index=True)
    password_hash = Column(String, nullable=True)
    name = Column(String)
    race = Column(String)
    role = Column(String)
    xp = Column(Integer, default=0)
