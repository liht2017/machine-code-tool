@echo off
chcp 65001 >nul
echo GitHub Setup Wizard...
echo.

echo Please select authentication method:
echo 1. Personal Access Token (Recommended)
echo 2. Username and Password
echo.
set /p AUTH_TYPE=Please select (1-2): 

if "%AUTH_TYPE%"=="1" goto TOKEN_AUTH
if "%AUTH_TYPE%"=="2" goto PASSWORD_AUTH
goto INVALID_CHOICE

:TOKEN_AUTH
echo.
echo === Personal Access Token Method ===
echo.
echo 1. Visit https://github.com/settings/tokens
echo 2. Click "Generate new token (classic)"
echo 3. Select "repo" permissions
echo 4. Generate and copy the token
echo.
pause
echo.
set /p USERNAME=Enter GitHub username: 
set /p TOKEN=Enter personal access token: 
set /p REPO_NAME=Enter repository name (e.g., machine-code-tool): 

if "%USERNAME%"=="" goto MISSING_INFO
if "%TOKEN%"=="" goto MISSING_INFO  
if "%REPO_NAME%"=="" goto MISSING_INFO

set REPO_URL=https://%USERNAME%:%TOKEN%@github.com/%USERNAME%/%REPO_NAME%.git
goto SETUP_GIT

:PASSWORD_AUTH
echo.
echo === Username and Password Method ===
echo.
set /p USERNAME=Enter GitHub username: 
set /p REPO_NAME=Enter repository name (e.g., machine-code-tool): 

if "%USERNAME%"=="" goto MISSING_INFO
if "%REPO_NAME%"=="" goto MISSING_INFO

set REPO_URL=https://github.com/%USERNAME%/%REPO_NAME%.git

echo.
echo Configuring Git to bypass SSL issues...
git config --global http.sslVerify false
git config --global http.postBuffer 524288000
git config --global http.maxRequestBuffer 100M
goto SETUP_GIT

:SETUP_GIT
echo.
echo Setting up Git repository...
git init
git add .
git commit -m "Initial commit: Machine Code Tool"

echo.
echo Adding remote repository...
git remote add origin %REPO_URL%

echo.
echo Pushing to GitHub...
git branch -M main
git push -u origin main

if errorlevel 1 (
    echo.
    echo Push failed!
    echo.
    echo Possible solutions:
    echo 1. Check network connection
    echo 2. Verify repository exists on GitHub
    echo 3. Check username and token are correct
    echo 4. Try using VPN or different network
    echo.
    pause
    exit /b 1
) else (
    echo.
    echo Push successful!
    echo.
    echo Repository: https://github.com/%USERNAME%/%REPO_NAME%
    echo Actions: https://github.com/%USERNAME%/%REPO_NAME%/actions
    echo Releases: https://github.com/%USERNAME%/%REPO_NAME%/releases
    echo.
    echo GitHub Actions will automatically start building cross-platform versions...
)
goto END

:MISSING_INFO
echo Error: Missing information, please run the script again
pause
exit /b 1

:INVALID_CHOICE
echo Invalid choice, please run the script again
pause
exit /b 1

:END
echo.
pause