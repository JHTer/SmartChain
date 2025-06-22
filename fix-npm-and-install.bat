@echo off
echo Fixing npm issues and installing dependencies...
echo.

echo Step 1: Clearing npm cache...
npm cache clean --force
echo.

echo Step 2: Removing package-lock.json if it exists...
if exist package-lock.json del package-lock.json
echo.

echo Step 3: Trying npm install with legacy peer deps...
npm install --legacy-peer-deps
echo.

echo Step 4: If that failed, trying with different npm registry...
npm install --registry https://registry.npmjs.org/
echo.

echo Step 5: Installing authentication packages one by one...
npm install @nestjs/jwt --legacy-peer-deps
npm install @nestjs/passport --legacy-peer-deps
npm install passport --legacy-peer-deps
npm install passport-jwt --legacy-peer-deps
npm install bcryptjs --legacy-peer-deps
npm install @types/bcryptjs --legacy-peer-deps --save-dev
npm install @types/passport-jwt --legacy-peer-deps --save-dev
echo.

echo Step 6: Generating Prisma client...
npx prisma generate
echo.

echo Installation complete! Testing if packages are installed...
dir node_modules | findstr -i "jwt\|passport\|bcrypt"
echo.
pause 