@echo off
echo Installing dependencies for SmartSupplyX Auth Service...
echo.

echo Step 1: Installing pnpm globally...
npm install -g pnpm
echo.

echo Step 2: Installing auth service dependencies...
cd /d D:\project\SmartChain\SmartChain\services\auth
npm install
echo.

echo Step 3: Generating Prisma client...
npx prisma generate
echo.

echo Dependencies installation complete!
echo You can now test the auth service by running:
echo   cd services\auth
echo   npm run start:dev
echo.
pause 