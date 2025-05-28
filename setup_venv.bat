@echo off
REM Change directory to the script location
cd /d %~dp0

REM Create the virtual environment in a "venv" folder
python -m venv venv

REM Check if venv creation succeeded
if exist venv\Scripts\activate.bat (
    echo Virtual environment created successfully.

    REM Activate the virtual environment
    echo Activating the virtual environment...
    call venv\Scripts\activate.bat

    REM Install required packages from requirements.txt if it exists
    if exist requirements.txt (
        echo Installing packages from requirements.txt...
        pip install -r requirements.txt
    ) else (
        echo No requirements.txt found. Skipping package installation.
    )

    REM Pause to keep the window open
    echo.
    echo Virtual environment is ready.
    pause
) else (
    echo Failed to create virtual environment.
    pause
)
