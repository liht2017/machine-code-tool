# 机器码获取工具

## 概述

机器码获取工具是一个跨平台的硬件信息获取应用，用于配合广联达SRM系统进行投标时的设备身份验证。

## 功能特性

- **跨平台支持**: Windows、macOS、银河麒麟
- **硬件信息获取**: MAC地址、主板序列号、CPU序列号、硬盘序列号
- **本地API服务**: 提供HTTP接口供业务系统调用
- **授权控制**: 用户可控制是否允许信息获取
- **安全传输**: 采用加密方式传输数据

## 系统要求

### Windows
- Windows 7 SP1 及以上版本
- 支持 32位 和 64位 系统

### macOS
- macOS 10.13 及以上版本
- 支持所有Mac设备 (Intel Mac通过Rosetta 2运行)

### 银河麒麟
- 银河麒麟桌面操作系统 V10 及以上版本
- 支持 x86_64 架构
- 大多数情况下开箱即用（系统通常已预装必要库）

## 下载和安装

### 使用方法
1. 下载对应平台的可执行文件
2. Windows: 双击 `.exe` 文件运行即可
3. macOS: 双击文件运行即可
4. 银河麒麟: 右键文件 → 属性 → 权限 → 勾选"允许作为程序执行文件" → 双击运行

## API接口

### 获取机器码信息
```
GET http://localhost:18888/api/machine-code
```

响应格式：
```json
{
  "success": true,
  "message": "获取成功",
  "data": {
    "mac": "00:1A:2B:3C:4D:5E",
    "motherboard": "MS-7A12-0101-0000000-123456",
    "cpu": "BFEBFBFF000906E9",
    "disk": "WDC_WD10EZEX-08WN4A0_WD-WCC6Y7123456",
    "version": "2.1.0"
  }
}
```

### 检查授权状态
```
GET http://localhost:18888/api/auth-status
```

### 设置授权状态
```
POST http://localhost:18888/api/set-auth
Content-Type: application/json

{
  "authorized": true
}
```

### 健康检查
```
GET http://localhost:18888/api/health
```

## 快速构建 (推荐)

### Windows用户

1. **如果没有安装Rust**，双击运行 `install-rust.bat`
2. **构建项目**，双击运行 `build.bat`
   - 脚本会自动安装Tauri CLI
   - 构建Tauri应用和安装包
3. 构建完成后，安装包位于 `release/machine-code-tool-windows.exe`

### macOS/Linux用户

1. **安装Rust**（如果没有安装）:
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
```

2. **构建项目**:
```bash
chmod +x build.sh
./build.sh
```

3. 构建完成后，安装包位于 `release/` 目录
   - macOS: `machine-code-tool-macos.dmg`
   - Linux: `machine-code-tool-kylin.deb`

## 详细构建步骤

### 环境要求
- Rust 1.70+（会自动安装最新版本）
- 支持的操作系统：Windows 7+, macOS 10.12+, Linux

### 手动构建

1. **安装Rust和Tauri CLI**
```bash
# 安装Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# 安装Tauri CLI
cargo install tauri-cli
```

2. **进入项目目录**
```bash
cd machine-code-tool
```

3. **构建项目**
```bash
# 开发版本
cargo tauri dev

# 发布版本（创建安装包）
cargo tauri build
```

4. **查找构建产物**
```bash
# 安装包位于：
# Windows: src-tauri/target/release/bundle/msi/ 或 bundle/nsis/
# macOS: src-tauri/target/release/bundle/dmg/
# Linux: src-tauri/target/release/bundle/deb/ 或 bundle/rpm/

# 可执行文件位于：
# src-tauri/target/release/machine-code-tool(.exe)
```

## 配置文件

配置文件位置：
- Windows: `%APPDATA%\machine-code-tool\config.json`
- macOS: `~/Library/Application Support/machine-code-tool/config.json`
- Linux: `~/.config/machine-code-tool/config.json`

配置格式：
```json
{
  "authorized": false,
  "auto_start": true,
  "port": 18888,
  "version": "2.1.0"
}
```

## 安全说明

- 工具仅获取必要的硬件标识信息
- 不会收集个人文件、浏览记录等敏感数据
- 数据传输采用HTTPS加密
- 用户可随时控制授权状态

## 故障排除

### 常见问题

1. **端口被占用**
   - 检查端口18888是否被其他程序占用
   - 可在配置文件中修改端口号

2. **获取硬件信息失败**
   - 确保以管理员权限运行
   - 检查防病毒软件是否阻止

3. **银河麒麟系统限制**
   - 目前仅支持获取MAC地址
   - 其他硬件信息显示为"————"

### 日志查看

日志文件位置：
- Windows: `%APPDATA%\machine-code-tool\logs\`
- macOS: `~/Library/Application Support/machine-code-tool/logs/`
- Linux: `~/.local/share/machine-code-tool/logs/`

## 使用说明

### 首次使用
1. 运行程序后，界面显示"未授权"状态
2. 点击"开启授权"按钮，允许获取硬件信息
3. 程序会自动启动HTTP服务（端口18888）
4. 点击"刷新信息"获取硬件信息

### 与SRM系统集成
- 程序启动后会在后台提供API服务
- SRM投标页面会自动调用本地API获取机器码
- 如果检测不到服务，会提示下载安装工具

### 常见问题

**Q: 构建时提示"cargo: command not found"**
A: 请先安装Rust环境，Windows用户可运行 `install-rust.bat`

**Q: 程序启动后无法获取硬件信息**
A: 请确保：
- 点击了"开启授权"按钮
- Windows用户可能需要管理员权限
- 防火墙允许程序运行

**Q: 端口18888被占用**
A: 请关闭占用该端口的其他程序，或修改源码中的端口号

**Q: 银河麒麟系统只能获取MAC地址**
A: 这是正常现象，该系统暂不支持获取其他硬件信息

## 技术栈

- **Rust**: 系统编程语言，高性能、内存安全
- **egui**: 轻量级GUI框架，跨平台支持
- **warp**: 高性能HTTP服务器
- **sysinfo**: 系统信息获取库
- **tokio**: 异步运行时

## 技术支持

如遇问题请联系：
- 客服电话：400-901-8866
- 邮箱：service@glodon.com
- 技术支持：tech-support@glodon.com

## 版权信息

© 2024 广联达科技股份有限公司 版权所有

本软件采用Rust语言开发，具有以下优势：
- 🚀 高性能：接近C/C++的运行速度
- 🛡️ 内存安全：避免常见的内存错误
- 🔧 易维护：现代化的包管理和构建系统
- 📦 小体积：单文件可执行程序，无需额外运行时