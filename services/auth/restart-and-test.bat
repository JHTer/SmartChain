@echo off
echo Restarting Auth Service (Simplified Version)...
echo.

echo Killing any existing Node processes...
taskkill /f /im node.exe 2>nul

echo Starting auth service...
start /B npm run start:dev

echo Waiting 8 seconds for service to start...
timeout /t 8 /nobreak > nul

echo.
echo Testing health endpoint...
curl -X POST http://localhost:3001/auth/health -H "Content-Type: application/json"

echo.
echo.
echo Testing signup endpoint...
curl -X POST http://localhost:3001/auth/signup -H "Content-Type: application/json" -d "{\"email\":\"test@example.com\",\"password\":\"password123\",\"tenantName\":\"Test Company\"}"

echo.
echo.
echo Testing login endpoint...
curl -X POST http://localhost:3001/auth/login -H "Content-Type: application/json" -d "{\"email\":\"test@example.com\",\"password\":\"password123\"}"

echo.
echo.
echo Service should now be running without compilation errors!
echo.
pause 