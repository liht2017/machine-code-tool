@echo off
chcp 65001 >nul
echo Simple GitHub Upload Tool
echo.

echo Step 1: Clear Git credentials
git config --global http.sslVerify false
git config --global credential.helper ""
cmdkey /delete:git:https://github.com 2>nul

echo Step 2: Initialize repository
git init
git add .
git commit -m "Initial commit: Machine Code Tool"

echo.
echo Step 3: Add remote repository
set /p REPO_URL=Enter GitHub repository URL: 
git remote add origin %REPO_URL%

echo.
echo Step 4: Push to GitHub
git branch -M main
git push -u origin main

echo.
echo Done! Check your GitHub repository for automatic builds.
pause