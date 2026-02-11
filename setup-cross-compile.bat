@echo off
echo 设置Rust交叉编译环境...
echo.

echo 1. 安装交叉编译目标...
rustup target add x86_64-pc-windows-msvc
rustup target add x86_64-apple-darwin
rustup target add aarch64-apple-darwin
rustup target add x86_64-unknown-linux-gnu
rustup target add aarch64-unknown-linux-gnu

echo.
echo 2. 安装交叉编译工具链...
cargo install cross

echo.
echo 3. 检查已安装的目标...
rustup target list --installed

echo.
echo 交叉编译环境设置完成！
pause