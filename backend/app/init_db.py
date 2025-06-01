from .db import Base, engine
from . import models


def init():
    print("📦 Creating tables...")
    Base.metadata.create_all(bind=engine)
    print("✅ Done.")

if __name__ == "__main__":
    init()

