@echo off
chcp 65001 >nul
echo Completely clean all Git configurations...
echo.

echo Step 1: Remove all Git remotes
git remote remove origin 2>nul
git remote remove gitee 2>nul
git remote remove github 2>nul

echo Step 2: Clear all Git credentials
git config --global --unset credential.helper 2>nul
git config --local --unset credential.helper 2>nul
cmdkey /delete:git:https://github.com 2>nul
cmdkey /delete:git:https://gitee.com 2>nul
cmdkey /delete:LegacyGeneric:git:https://github.com 2>nul
cmdkey /delete:LegacyGeneric:git:https://gitee.com 2>nul

echo Step 3: Remove .git directory completely
if exist ".git" (
    rmdir /s /q .git
    echo Removed .git directory
)

echo Step 4: Reinitialize Git repository
git init
git config user.name "GitHub User"
git config user.email "user@github.com"

echo Step 5: Add all files
git add .
git commit -m "Clean initial commit: Machine Code Tool"

echo.
echo Git repository completely cleaned and reinitialized!
echo Now you can add GitHub remote safely.
echo.
pause