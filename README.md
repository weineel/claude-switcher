# Claude Proxy Checker

智能代理检查和Claude启动工具

## 概述

`claude-proxy-checker` 是一个智能脚本，用于检查IP地理位置、配置代理设置，并帮助用户选择最佳的Claude AI启动方式。

## 核心功能

- 🌍 **智能IP地理位置检测** - 自动检测当前IP位置
- 🔄 **灵活的代理配置** - 支持默认代理和自定义代理设置
- 🚀 **双启动模式** - 支持普通Claude和anyrouter两种启动方式
- 🔐 **安全Token管理** - 安全存储和管理Anthropic Auth Token
- 📊 **用户偏好记忆** - 记住用户上次的选择配置
- 🎨 **友好的交互界面** - 彩色输出和清晰的操作指引

## 启动方式

### 1. 启动 Claude
- 适用于IP位置在美国的用户
- 如果IP不在美国，自动提供代理设置选项

### 2. 启动 Claude (anyrouter)
- 适用于所有地区的用户
- 无需复杂的代理设置
- 需要anyrouter Token (免费注册获取)

## 使用方法

### 基本使用
```bash
./claude-proxy-checker.sh
```

### 命令行参数
```bash
./claude-proxy-checker.sh --help              # 显示帮助信息
./claude-proxy-checker.sh --anyrouter         # 直接启动anyrouter
./claude-proxy-checker.sh --proxy <url>       # 使用指定代理
./claude-proxy-checker.sh --quick             # 使用上次保存的配置
./claude-proxy-checker.sh --skip-geo          # 跳过地理位置检测
./claude-proxy-checker.sh --reset             # 重置所有配置
```

## Token获取

### Anyrouter Token
1. 访问: https://anyrouter.top/register?aff=eg0D
2. 注册账户并登录
3. 在用户面板中找到 API Token
4. 复制Token到脚本中使用

## 系统要求

- **操作系统**: macOS/Linux
- **依赖工具**: bash, curl
- **网络连接**: 需要网络连接进行地理位置检测

## 配置文件

脚本会在 `~/.claude_proxy_config` 中保存用户配置：
- Anthropic Auth Token (加密存储)
- 用户偏好设置
- 上次使用的代理配置

## 工作流程

1. **启动选择** - 用户选择启动方式
2. **智能检测** - 根据选择决定是否检查IP位置
3. **代理配置** - 如需要，提供代理设置选项
4. **Token管理** - 安全处理和存储Token
5. **服务启动** - 启动相应的Claude服务

## 安全特性

- 🔒 Token隐藏输入 (`read -s`)
- 🛡️ 配置文件权限保护 (600)
- 🔐 原始代理设置自动恢复
- 🚨 输入验证和错误处理

## 示例

```bash
# 快速启动anyrouter
./claude-proxy-checker.sh --anyrouter

# 使用自定义代理
./claude-proxy-checker.sh --proxy http://127.0.0.1:8080

# 使用保存的配置快速启动
./claude-proxy-checker.sh --quick
```

## 许可证

MIT License

## 贡献

欢迎提交Issues和Pull Requests来改进这个工具。
