from db import SessionLocal
from sqlalchemy import text


def test_connection():
    try:
        db = SessionLocal()
        result = db.execute(text("SELECT 1")).scalar()
        print("✅ Connection successful. Result:", result)
    except Exception as e:
        print("❌ Connection failed:", e)
    finally:
        db.close()

if __name__ == "__main__":
    test_connection()
