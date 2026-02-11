@echo off
chcp 65001 >nul
echo 跨平台构建机器码工具...
echo.

cd src-tauri

echo ========================================
echo 构建Windows版本 (x86_64)...
echo ========================================
cargo build --release --target x86_64-pc-windows-msvc
if errorlevel 1 (
    echo Windows构建失败！
    pause
    exit /b 1
)

echo.
echo ========================================
echo 构建macOS版本 (Intel x86_64)...
echo ========================================
cargo build --release --target x86_64-apple-darwin
if errorlevel 1 (
    echo macOS Intel构建失败，尝试使用cross...
    cross build --release --target x86_64-apple-darwin
)

echo.
echo ========================================
echo 构建macOS版本 (Apple Silicon ARM64)...
echo ========================================
cargo build --release --target aarch64-apple-darwin
if errorlevel 1 (
    echo macOS ARM构建失败，尝试使用cross...
    cross build --release --target aarch64-apple-darwin
)

echo.
echo ========================================
echo 构建Linux版本 (x86_64)...
echo ========================================
cargo build --release --target x86_64-unknown-linux-gnu
if errorlevel 1 (
    echo Linux构建失败，尝试使用cross...
    cross build --release --target x86_64-unknown-linux-gnu
)

cd ..

echo.
echo ========================================
echo 整理构建产物...
echo ========================================

if not exist "release-cross" mkdir release-cross

echo 复制Windows版本...
if exist "src-tauri\target\x86_64-pc-windows-msvc\release\machine-code-tool.exe" (
    copy "src-tauri\target\x86_64-pc-windows-msvc\release\machine-code-tool.exe" "release-cross\machine-code-tool-windows.exe"
    echo ✅ Windows版本构建成功
) else (
    echo ❌ Windows版本构建失败
)

echo 复制macOS Intel版本...
if exist "src-tauri\target\x86_64-apple-darwin\release\machine-code-tool" (
    copy "src-tauri\target\x86_64-apple-darwin\release\machine-code-tool" "release-cross\machine-code-tool-macos-intel"
    echo ✅ macOS Intel版本构建成功
) else (
    echo ❌ macOS Intel版本构建失败
)

echo 复制macOS ARM版本...
if exist "src-tauri\target\aarch64-apple-darwin\release\machine-code-tool" (
    copy "src-tauri\target\aarch64-apple-darwin\release\machine-code-tool" "release-cross\machine-code-tool-macos-arm"
    echo ✅ macOS ARM版本构建成功
) else (
    echo ❌ macOS ARM版本构建失败
)

echo 复制Linux版本...
if exist "src-tauri\target\x86_64-unknown-linux-gnu\release\machine-code-tool" (
    copy "src-tauri\target\x86_64-unknown-linux-gnu\release\machine-code-tool" "release-cross\machine-code-tool-kylin"
    echo ✅ Linux版本构建成功
) else (
    echo ❌ Linux版本构建失败
)

echo.
echo ========================================
echo 构建完成！
echo ========================================
echo.
echo 构建产物位于 release-cross\ 目录：
dir release-cross\ /b
echo.
echo 注意：
echo - macOS和Linux版本可能需要在对应系统上测试
echo - 某些系统特定功能可能无法在交叉编译中正常工作
echo - 如果交叉编译失败，建议在对应系统上原生编译
echo.
pause