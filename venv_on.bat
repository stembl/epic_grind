@echo off
cd /d %~dp0

REM Check if the venv activation script exists
if not exist venv\Scripts\activate.bat (
    echo ❌ No virtual environment found in "venv\" folder.
    echo 💡 Run setup_venv_311.bat first to create one with Python 3.11.
    pause
    exit /b 1
)

REM Activate the virtual environment
call venv\Scripts\activate.bat

REM Get the Python version string
for /f "tokens=2 delims= " %%v in ('python --version') do set PYVERSION=%%v

REM Check if it starts with 3.11
echo %PYVERSION% | findstr /b "3.11" >nul
if errorlevel 1 (
    echo ❌ ERROR: This venv is using Python %PYVERSION%, not 3.11.
    echo 💡 You should recreate the venv using Python 3.11.
    deactivate
    pause
    exit /b 1
)

echo ✅ Python %PYVERSION% venv activated successfully.
