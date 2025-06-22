@echo off
echo Quick Test - Auth Service Compilation
echo.

echo Killing any existing Node processes...
taskkill /f /im node.exe 2>nul

echo.
echo Starting service (will show compilation status)...
npm run start:dev

echo.
pause 