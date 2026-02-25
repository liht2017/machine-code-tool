# 麒麟 / Linux 构建说明

## 两种方式

| 方式 | Dockerfile | 耗时 | 目标系统 glibc | 说明 |
|------|------------|------|----------------------|------|
| **现成包（推荐先试）** | `Dockerfile.kylin-apt` | **约 5～10 分钟** | **≥ 2.34**（如 Ubuntu 22.04、麒麟升级后） | 使用 `apt install libwebkit2gtk-4.1-dev`，无需编 WebKit |
| 自编 WebKit | `Dockerfile.kylin` | 约 1～2 小时（首轮） | 2.31（未升级的麒麟 V10） | 在 Ubuntu 20.04 里从源码编 WebKit2GTK 4.1 |

## 怎么选

- **目标环境 glibc 未知或 ≥ 2.34**：先跑 **“构建麒麟版 AppImage（apt 现成包，快速）”** 工作流，得到的 AppImage 在目标机器上试运行；若提示 glibc 版本不够再改用 glibc 2.31 的自编方案。
- **明确是未升级的麒麟 V10（glibc 2.31）**：用 **“构建麒麟版 AppImage (glibc 2.31)”** 工作流（自编 WebKit，耗时长但兼容 2.31）。

## 现成包来源

- **Ubuntu 22.04** 官方源：`libwebkit2gtk-4.1-0` / `libwebkit2gtk-4.1-dev`，Tauri v2 所需 WebKit2GTK 4.1 可直接 apt 安装。
- **Ubuntu 20.04** 官方源只有 WebKit2GTK 4.0，没有 4.1，故 20.04 + glibc 2.31 只能自编 WebKit。
