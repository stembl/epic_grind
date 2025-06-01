@echo off
cd /d %~dp0


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
