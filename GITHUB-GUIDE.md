# GitHub自动化构建指南

## 🌐 **GitHub Actions方案**

使用GitHub的免费CI/CD服务进行跨平台自动构建。

## 🚀 **快速开始**

### **1. 上传到GitHub**
```bash
# 运行GitHub设置向导
github-setup-complete.bat

# 或者简单上传
upload-to-github.bat
```

### **2. 自动构建**
- **推送代码**: 自动构建所有平台
- **创建标签**: 自动构建 + 创建Release
- **手动触发**: 在GitHub网页上手动开始

### **3. 下载构建产物**
- **Actions页面**: 下载Artifacts
- **Releases页面**: 下载正式版本

## 📋 **使用流程**

### **日常开发**
```bash
# 1. 修改代码后推送
deploy-github.bat
# 选择选项1: 推送代码触发构建

# 2. 查看构建状态
# 访问: https://github.com/用户名/machine-code-tool/actions
```

### **版本发布**
```bash
# 1. 创建版本标签
deploy-github.bat  
# 选择选项2: 创建版本标签触发Release

# 2. 自动创建Release
# 访问: https://github.com/用户名/machine-code-tool/releases
```

## 🔧 **构建配置**

### **自动构建平台**
- ✅ **Windows**: `machine-code-tool-windows.exe`
- ✅ **macOS Intel**: `machine-code-tool-macos-intel`
- ✅ **macOS ARM**: `machine-code-tool-macos-arm`
- ✅ **Linux**: `machine-code-tool-kylin`

### **构建时间**
- **总时间**: 约10-20分钟
- **Windows**: 3-5分钟
- **macOS**: 5-8分钟
- **Linux**: 3-5分钟

## 🔗 **重要链接**

- **GitHub官网**: https://github.com
- **GitHub Actions**: https://github.com/features/actions
- **创建仓库**: https://github.com/new

## 💡 **最佳实践**

1. **代码质量**: 本地测试通过后再推送
2. **合理标签**: 使用语义化版本号 (v2.1.0)
3. **监控构建**: 及时查看构建状态和日志
4. **及时下载**: 构建产物有保存期限

## 🆘 **常见问题**

### **Q: 网络访问问题**
A: 可能需要科学上网或使用代理

### **Q: 构建失败**
A: 查看Actions页面的构建日志

### **Q: 下载速度慢**
A: 可以使用GitHub代理或镜像站点

### **Q: 如何加速访问**
A: 
1. 使用GitHub代理服务
2. 配置Git代理
3. 使用镜像站点下载

## 📦 **构建产物说明**

### **Artifacts (临时下载)**
- 保存期限: 90天
- 下载位置: Actions页面 → 具体构建 → Artifacts
- 适用于: 测试和开发

### **Releases (正式版本)**
- 保存期限: 永久
- 下载位置: Releases页面
- 适用于: 生产使用和分发

现在专注使用GitHub进行自动化构建！