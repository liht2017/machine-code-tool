@echo off
chcp 65001 >nul
echo 使用Docker进行跨平台构建...
echo.

echo 检查Docker是否安装...
docker --version >nul 2>&1
if errorlevel 1 (
    echo 错误: 未找到Docker
    echo 请先安装Docker Desktop: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

echo Docker检查通过
echo.

if not exist "release-docker" mkdir release-docker

echo ========================================
echo 构建Linux x86_64版本...
echo ========================================
docker buildx build --platform linux/amd64 --output type=local,dest=./release-docker/linux-amd64 -f Dockerfile.cross .

echo.
echo ========================================
echo 构建Linux ARM64版本...
echo ========================================
docker buildx build --platform linux/arm64 --output type=local,dest=./release-docker/linux-arm64 -f Dockerfile.cross .

echo.
echo ========================================
echo 整理构建产物...
echo ========================================

if exist "release-docker\linux-amd64\machine-code-tool" (
    copy "release-docker\linux-amd64\machine-code-tool" "release-docker\machine-code-tool-kylin-x64"
    echo ✅ Linux x86_64版本构建成功
)

if exist "release-docker\linux-arm64\machine-code-tool" (
    copy "release-docker\linux-arm64\machine-code-tool" "release-docker\machine-code-tool-kylin-arm64"
    echo ✅ Linux ARM64版本构建成功
)

echo.
echo 构建完成！产物位于 release-docker\ 目录
dir release-docker\ /b
pause