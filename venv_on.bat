@echo off

echo Activating virtual environment...
call venv\Scripts\activate.bat

REM === Upgrade pip ===
echo Upgrading pip...
python -m pip install --upgrade pip

REM === Install required packages ===
echo Installing required packages...
pip install -r requirements.txt

echo.
echo ✅ Code environment ready.