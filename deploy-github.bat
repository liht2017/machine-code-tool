@echo off
chcp 65001 >nul
echo GitHub Actions自动化构建部署...
echo.

echo 请选择操作：
echo 1. 推送代码触发构建
echo 2. 创建版本标签触发Release
echo 3. 手动触发构建
echo 4. 查看构建状态
echo.
set /p CHOICE=请选择 (1-4): 

if "%CHOICE%"=="1" goto PUSH_CODE
if "%CHOICE%"=="2" goto CREATE_TAG  
if "%CHOICE%"=="3" goto MANUAL_BUILD
if "%CHOICE%"=="4" goto CHECK_STATUS
goto INVALID_CHOICE

:PUSH_CODE
echo.
echo 推送代码到GitHub...
git add .
set /p COMMIT_MSG=请输入提交信息: 
if "%COMMIT_MSG%"=="" set COMMIT_MSG=更新代码
git commit -m "%COMMIT_MSG%"
git push origin main
echo.
echo 代码已推送，Actions将自动开始构建
goto SHOW_LINKS

:CREATE_TAG
echo.
set /p TAG_NAME=请输入版本标签 (例如 v2.1.0): 
if "%TAG_NAME%"=="" (
    echo 错误: 版本标签不能为空
    pause
    exit /b 1
)
git add .
git commit -m "发布版本 %TAG_NAME%"
git tag %TAG_NAME%
git push origin main
git push origin %TAG_NAME%
echo.
echo 版本标签已创建，Actions将自动构建并创建Release
goto SHOW_LINKS

:MANUAL_BUILD
echo.
echo 手动触发构建需要在GitHub网页上操作：
echo 1. 访问你的仓库Actions页面
echo 2. 选择 "跨平台构建" workflow
echo 3. 点击 "Run workflow" 按钮
echo 4. 可选择输入版本号
echo 5. 点击 "Run workflow" 开始构建
goto SHOW_LINKS

:CHECK_STATUS
echo.
echo 请访问以下链接查看构建状态：
goto SHOW_LINKS

:SHOW_LINKS
echo.
echo ========================================
echo 🔗 相关链接
echo ========================================
git remote get-url origin > temp_url.txt
set /p REPO_URL=<temp_url.txt
del temp_url.txt

for /f "tokens=3 delims=/" %%a in ("%REPO_URL%") do set GITHUB_USER=%%a
for /f "tokens=4 delims=/ " %%a in ("%REPO_URL%") do set REPO_NAME=%%a
set REPO_NAME=%REPO_NAME:.git=%

echo 📁 仓库地址: https://github.com/%GITHUB_USER%/%REPO_NAME%
echo 🔄 Actions页面: https://github.com/%GITHUB_USER%/%REPO_NAME%/actions
echo 📦 Releases页面: https://github.com/%GITHUB_USER%/%REPO_NAME%/releases
echo 📊 构建状态: https://github.com/%GITHUB_USER%/%REPO_NAME%/actions/workflows/build.yml
echo.
echo 💡 提示：
echo - 构建通常需要5-15分钟
echo - 可以在Actions页面实时查看构建进度
echo - 构建完成后可在Artifacts中下载文件
echo - 创建标签会自动生成Release
goto END

:INVALID_CHOICE
echo 无效选择，请重新运行脚本
pause
exit /b 1

:END
echo.
pause