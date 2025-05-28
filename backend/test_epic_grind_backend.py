import sqlite3
import requests
import time
import os

BASE_URL = "http://127.0.0.1:8000"

test_character = {
    "user_id": "test_orc001",
    "name": "Test Grog",
    "race": "Orc",
    "role": "Tank",
    "xp": 0
}
xp_update = {
    "user_id": "test_orc001",
    "amount": 15
}
analytics_event = {
    "user_id": "test_orc001",
    "event_type": "quest_tested",
    "details": {"quest_id": "unit_test_quest"}
}

results = []

def test_status():
    try:
        r = requests.get(f"{BASE_URL}/status")
        expected = {"status": "ok"}
        passed = r.status_code == 200 and r.json() == expected
        results.append(("GET /status", passed, r.json()))
    except Exception as e:
        results.append(("GET /status", False, str(e)))

def test_create_character():
    try:
        r = requests.post(f"{BASE_URL}/character", json=test_character)
        data = r.json()
        passed = r.status_code == 200 and data.get("character", {}).get("user_id") == test_character["user_id"]
        results.append(("POST /character", passed, data))
    except Exception as e:
        results.append(("POST /character", False, str(e)))

def test_get_character():
    try:
        r = requests.get(f"{BASE_URL}/character/{test_character['user_id']}")
        data = r.json()
        passed = r.status_code == 200 and data["user_id"] == test_character["user_id"]
        results.append(("GET /character/{id}", passed, data))
    except Exception as e:
        results.append(("GET /character/{id}", False, str(e)))

def test_update_xp():
    try:
        r = requests.post(f"{BASE_URL}/xp", json=xp_update)
        data = r.json()
        passed = r.status_code == 200 and data.get("new_xp", -1) >= xp_update["amount"]
        results.append(("POST /xp", passed, data))
    except Exception as e:
        results.append(("POST /xp", False, str(e)))

def test_analytics():
    try:
        r = requests.post(f"{BASE_URL}/analytics", json=analytics_event)
        data = r.json()
        passed = r.status_code == 200 and data.get("message") == "Event logged"
        results.append(("POST /analytics", passed, data))
    except Exception as e:
        results.append(("POST /analytics", False, str(e)))

def cleanup_test_data():
    try:
        db_path = os.path.join(os.path.dirname(__file__), "epic_grind.db")
        print("DB Path:", db_path)
        print("Exists:", os.path.exists(db_path))
        print("Writeable directory:", os.access(os.path.dirname(db_path), os.W_OK))
        print("File writeable:", os.access(db_path, os.W_OK) if os.path.exists(db_path) else "File not found")

        conn = sqlite3.connect(db_path)
        cur = conn.cursor()
        cur.execute("DELETE FROM characters WHERE user_id = ?", (test_character["user_id"],))
        conn.commit()
        conn.close()
    except Exception as e:
        results.append(("DB Cleanup", False, str(e)))
    else:
        results.append(("DB Cleanup", True, "Test user deleted"))

def print_results():
    print("\n==== TEST RESULTS ====")
    for name, passed, info in results:
        status = "✅ PASS" if passed else "❌ FAIL"
        print(f"{status} - {name}")
        print(f"     Response: {info}")
    print("======================")

if __name__ == "__main__":
    test_status()
    test_create_character()
    time.sleep(0.5)
    test_get_character()
    test_update_xp()
    test_analytics()
    cleanup_test_data()
    print_results()
