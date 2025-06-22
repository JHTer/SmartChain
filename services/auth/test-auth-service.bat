@echo off
echo Testing SmartSupplyX Auth Service...
echo.

echo Starting auth service...
echo (This will start the service in the background)
start /B npm run start:dev

echo Waiting 5 seconds for service to start...
timeout /t 5 /nobreak > nul

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
echo Auth service test complete!
echo The service is running on http://localhost:3001
echo.
pause 