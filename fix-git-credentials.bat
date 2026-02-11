@echo off
chcp 65001 >nul
echo 修复Git凭据配置问题...
echo.

echo 当前Git配置：
echo ========================================
git config --global --list | findstr "credential\|user\|remote"
echo.

echo 清除Git凭据缓存...
echo ========================================

REM 清除全局凭据助手
git config --global --unset credential.helper 2>nul
echo 已清除全局credential.helper

REM 清除本地凭据助手  
git config --local --unset credential.helper 2>nul
echo 已清除本地credential.helper

REM 清除Windows凭据管理器中的GitHub凭据
cmdkey /delete:git:https://github.com 2>nul
echo 已清除GitHub凭据

REM 清除Windows凭据管理器中的Gitee凭据
cmdkey /delete:git:https://gitee.com 2>nul  
echo 已清除Gitee凭据

REM 清除可能的其他凭据
cmdkey /delete:LegacyGeneric:git:https://github.com 2>nul
cmdkey /delete:LegacyGeneric:git:https://gitee.com 2>nul

echo.
echo 设置Git使用每次询问密码...
git config --global credential.helper ""

echo.
echo 检查是否有远程仓库配置...
git remote -v 2>nul
if errorlevel 1 (
    echo 当前目录不是Git仓库
) else (
    echo.
    echo 如果需要更改远程仓库地址，请运行：
    echo git remote set-url origin 新的仓库地址
)

echo.
echo ========================================
echo 修复完成！
echo ========================================
echo.
echo 现在Git会在每次推送时询问用户名和密码
echo 这样可以避免使用错误的凭据
echo.
echo 建议：
echo 1. 使用Gitee的私人令牌代替密码
echo 2. 在仓库URL中包含用户名和令牌
echo 3. 格式: https://用户名:令牌@gitee.com/用户名/仓库名.git
echo.
pause