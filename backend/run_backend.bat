@echo off
REM Use Python 3.11 to create and activate virtual environment

SET PYTHON_EXE=python

REM Try Python 3.11 first
where python3.11 >nul 2>nul
IF %ERRORLEVEL%==0 (
    SET PYTHON_EXE=python3.11
)

%PYTHON_EXE% -m venv venv

CALL venv\Scripts\activate

pip install -r requirements.txt

uvicorn app.main:app --reload

pause
