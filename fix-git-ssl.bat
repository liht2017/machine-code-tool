@echo off
chcp 65001 >nul
echo 修复Git SSL证书问题...
echo.

echo 方案1: 临时禁用SSL验证 (快速解决)
echo ========================================
git config --global http.sslVerify false
echo SSL验证已禁用

echo.
echo 方案2: 设置代理绕过 (如果使用代理)
echo ========================================
echo 如果你在使用代理，请手动执行以下命令：
echo git config --global http.proxy http://代理地址:端口
echo git config --global https.proxy https://代理地址:端口

echo.
echo 方案3: 更新Git证书
echo ========================================
git config --global http.sslCAInfo ""
git config --global http.sslCAPath ""

echo.
echo 现在尝试重新推送...
git push origin main

if errorlevel 1 (
    echo.
    echo 如果仍然失败，请尝试以下命令：
    echo git config --global http.postBuffer 524288000
    echo git config --global http.maxRequestBuffer 100M
    echo git config --global core.compression 0
    echo.
    echo 然后重新运行: git push origin main
) else (
    echo.
    echo ✅ 推送成功！
)

echo.
echo 注意：为了安全，建议推送成功后重新启用SSL验证：
echo git config --global http.sslVerify true
echo.
pause