@echo off
REM ============================================================================
REM Windows Activation Manager - Run as Administrator
REM ============================================================================

echo.
echo Requesting Administrator privileges...
echo.

powershell.exe -ExecutionPolicy Bypass -File "%~dp0Activate-Windows.ps1"

if errorlevel 1 (
    echo.
    echo ERROR: Failed to run the activation script.
    echo Please make sure you run this as Administrator.
    echo.
    pause
    exit /b 1
)

exit /b 0
