@echo off
chcp 65001 >nul
echo GitHub完整设置向导...
echo.

echo 请选择认证方式：
echo 1. 使用个人访问令牌 (推荐)
echo 2. 使用用户名密码 (可能需要禁用SSL)
echo.
set /p AUTH_TYPE=请选择 (1-2): 

if "%AUTH_TYPE%"=="1" goto TOKEN_AUTH
if "%AUTH_TYPE%"=="2" goto PASSWORD_AUTH
goto INVALID_CHOICE

:TOKEN_AUTH
echo.
echo === 个人访问令牌方式 ===
echo.
echo 1. 请先访问 https://github.com/settings/tokens
echo 2. 点击 "Generate new token (classic)"
echo 3. 选择 "repo" 权限
echo 4. 生成并复制令牌
echo.
pause
echo.
set /p USERNAME=请输入GitHub用户名: 
set /p TOKEN=请输入个人访问令牌: 
set /p REPO_NAME=请输入仓库名 (例如: machine-code-tool): 

if "%USERNAME%"=="" goto MISSING_INFO
if "%TOKEN%"=="" goto MISSING_INFO  
if "%REPO_NAME%"=="" goto MISSING_INFO

set REPO_URL=https://%USERNAME%:%TOKEN%@github.com/%USERNAME%/%REPO_NAME%.git
goto SETUP_GIT

:PASSWORD_AUTH
echo.
echo === 用户名密码方式 ===
echo.
set /p USERNAME=请输入GitHub用户名: 
set /p REPO_NAME=请输入仓库名 (例如: machine-code-tool): 

if "%USERNAME%"=="" goto MISSING_INFO
if "%REPO_NAME%"=="" goto MISSING_INFO

set REPO_URL=https://github.com/%USERNAME%/%REPO_NAME%.git

echo.
echo 配置Git绕过SSL问题...
git config --global http.sslVerify false
git config --global http.postBuffer 524288000
git config --global http.maxRequestBuffer 100M
goto SETUP_GIT

:SETUP_GIT
echo.
echo 设置Git仓库...
git init
git add .
git commit -m "初始提交: 机器码获取工具"

echo.
echo 添加远程仓库...
git remote add origin %REPO_URL%

echo.
echo 推送到GitHub...
git branch -M main
git push -u origin main

if errorlevel 1 (
    echo.
    echo ❌ 推送失败！
    echo.
    echo 可能的解决方案：
    echo 1. 检查网络连接
    echo 2. 确认仓库已在GitHub上创建
    echo 3. 验证用户名和令牌是否正确
    echo 4. 尝试使用VPN或更换网络
    echo.
    pause
    exit /b 1
) else (
    echo.
    echo ✅ 推送成功！
    echo.
    echo 🔗 仓库地址: https://github.com/%USERNAME%/%REPO_NAME%
    echo 🔄 Actions页面: https://github.com/%USERNAME%/%REPO_NAME%/actions
    echo 📦 Releases页面: https://github.com/%USERNAME%/%REPO_NAME%/releases
    echo.
    echo GitHub Actions将自动开始构建跨平台版本...
)
goto END

:MISSING_INFO
echo 错误: 信息不完整，请重新运行脚本
pause
exit /b 1

:INVALID_CHOICE
echo 无效选择，请重新运行脚本
pause
exit /b 1

:END
echo.
pause