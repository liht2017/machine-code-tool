# 麒麟 / Linux 构建说明

项目已使用 **Tauri v1**，Linux 端依赖 **WebKit2GTK 4.0**（系统包即可，无需自编）。

## 推荐：麒麟版快速构建（apt）

| 项目 | 说明 |
|------|------|
| **Dockerfile** | `Dockerfile.kylin-apt` |
| **工作流** | 「构建麒麟版 AppImage（Tauri v1 + apt，快速）」 |
| **耗时** | 约 5～10 分钟（无 WebKit 源码编译） |
| **基础镜像** | Ubuntu 20.04，`apt install libwebkit2gtk-4.0-dev` |
| **目标系统** | 麒麟 V10、Ubuntu 20.04 等（glibc 2.31） |

**目标机运行前**：若未预装 WebKit，用户执行  
`sudo apt install libwebkit2gtk-4.0-37`（或 `libwebkit2gtk-4.0`）即可。

## 可选：从源码编 WebKit（glibc 2.31 且无 4.0 包时）

若目标机无法安装 libwebkit2gtk-4.0（例如极老系统），可使用 `Dockerfile.kylin` + 工作流「构建麒麟版 AppImage (glibc 2.31)」，在 Ubuntu 20.04 内自编 WebKit2GTK 4.1 再打 Tauri v1 应用（需约 1～2 小时，建议用 CI 缓存）。
