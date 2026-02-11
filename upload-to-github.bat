@echo off
chcp 65001 >nul
echo 上传代码到GitHub...
echo.

echo 请先在GitHub创建仓库，然后输入仓库地址
echo 格式: https://github.com/liht2017/machine-code-tool.git
set /p REPO_URL=请输入GitHub仓库地址: 

if "%REPO_URL%"=="" (
    echo 错误: 仓库地址不能为空
    pause
    exit /b 1
)

echo.
echo 配置Git环境...
git config --global http.sslVerify false
git config --global http.postBuffer 524288000

echo.
echo 初始化Git仓库...
git init

echo.
echo 添加所有文件...
git add .

echo.
echo 创建首次提交...
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
    echo 推送失败，尝试其他方法...
    echo 尝试使用token认证...
    echo 请访问 https://github.com/settings/tokens 生成个人访问令牌
    echo 然后使用以下格式的URL：
    echo https://用户名:token@github.com/用户名/仓库名.git
    pause
    exit /b 1
)

echo.
echo ========================================
echo 代码上传完成！
echo ========================================
echo.
echo 现在可以访问你的GitHub仓库查看Actions构建状态：
echo %REPO_URL%
echo.
echo Actions页面: %REPO_URL%/actions
echo.
pause