@echo off
chcp 65001 >nul
echo 检查Git配置状态...
echo.

echo 🔍 全局Git配置:
echo ========================================
git config --global --list 2>nul | findstr -i "credential\|user\|github\|gitee"
echo.

echo 🔍 本地Git配置:
echo ========================================
git config --local --list 2>nul | findstr -i "credential\|user\|remote\|github\|gitee"
echo.

echo 🔍 远程仓库配置:
echo ========================================
git remote -v 2>nul
echo.

echo 🔍 Windows凭据管理器:
echo ========================================
cmdkey /list | findstr -i "git\|github\|gitee"
echo.

echo 🔍 当前分支:
echo ========================================
git branch 2>nul
echo.

echo 🔍 最近提交:
echo ========================================
git log --oneline -3 2>nul
echo.

pause