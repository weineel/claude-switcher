# Claude Switcher

简单易用的Claude配置管理工具 - 让你轻松在不同环境下使用Claude

## 🌟 特性

- 🚀 **一键启动** - 运行 `claude-switcher` 即可开始使用
- 📋 **配置管理** - 创建和管理多个Claude配置
- 🔄 **快速切换** - 图形化选择界面，一目了然  
- 🌍 **IP检查** - 启动前自动检查出口IP地址
- 🔒 **安全存储** - 配置文件权限保护
- 🎨 **友好界面** - 清晰的彩色输出

## 📦 安装

### 一键安装
```bash
curl -sSL https://raw.githubusercontent.com/fiftyk/claude-switcher/main/install.sh | bash
```

### 手动安装
```bash
# 下载脚本
curl -L https://raw.githubusercontent.com/fiftyk/claude-switcher/main/claude-switcher.sh -o claude-switcher.sh

# 设置权限并安装
chmod +x claude-switcher.sh
sudo mv claude-switcher.sh /usr/local/bin/claude-switcher
```

## 🚀 使用方法

### 启动程序
```bash
claude-switcher
```

### 操作流程

1. **首次运行** - 会显示配置选择界面
2. **选择配置** - 从列表中选择已有配置，或创建新配置
3. **配置操作** - 对于已有配置，可以选择启动或编辑
4. **创建配置** - 按提示依次输入配置信息
5. **启动Claude** - 自动设置环境变量并启动Claude

### 交互界面示例

```
=== Claude Switcher ===

=== 可用配置 ===
  1) anyrouter - 使用anyrouter服务
  2) proxy - 使用代理连接
  3) [创建新配置]

请选择配置 [1-3]: 1

=== 配置: anyrouter ===
ℹ 配置概要:
  Base URL: https://anyrouter.top
  Auth Token: sk-ant***
  代理: 未设置

选择操作:
  1) 启动 Claude  
  2) 查看/编辑配置

请选择 [1-2]: 1

=== 启动 Claude - 配置: anyrouter ===
ℹ 检查出口IP地址...
ℹ 出口IP: 1.2.3.4
ℹ 位置: United States, New York
ℹ 环境变量已设置
✓ 正在启动 Claude...
```

## 📝 配置文件格式

配置文件使用简单的 Shell 变量格式：

```bash
# Claude Switcher 配置文件
NAME="我的anyrouter配置"
ANTHROPIC_AUTH_TOKEN="sk-ant-xxxx"
ANTHROPIC_BASE_URL="https://anyrouter.top"
http_proxy="http://127.0.0.1:7890"
https_proxy="http://127.0.0.1:7890"
```

## 🔧 创建配置流程

运行程序后选择"创建新配置"，然后按提示输入：

1. **配置名称** - 给配置起个名字，如 "work", "home"
2. **ANTHROPIC_BASE_URL** - API端点，留空使用默认
3. **ANTHROPIC_AUTH_TOKEN** - 你的Claude认证Token  
4. **代理设置** - 代理地址，留空不使用代理

## 🌍 常用配置示例

### anyrouter配置
- **Base URL**: `https://anyrouter.top`
- **Token**: 你的anyrouter token
- **代理**: 留空

### 代理配置  
- **Base URL**: 留空(使用默认)
- **Token**: 你的官方Claude token
- **代理**: `http://127.0.0.1:7890`

### 直连配置
- **Base URL**: 留空(使用默认)  
- **Token**: 你的官方Claude token
- **代理**: 留空

## 📁 文件位置

- 配置目录: `~/.claude-switcher/`
- 配置文件: `~/.claude-switcher/profiles/*.conf`

## 🔒 安全说明

- 配置文件权限设置为 600 (仅用户可读写)
- Token 在界面中显示时自动掩码
- 启动前保存原环境变量，退出后自动恢复

## 📋 系统要求

- macOS 或 Linux
- bash, curl 
- Claude CLI (用于启动Claude)

## 🔄 从旧版本迁移

如果你之前使用的是 `claude-proxy-checker`，安装脚本会自动检测并提示删除：

```bash
# 一键安装 - 会自动检测旧版本
curl -sSL https://raw.githubusercontent.com/fiftyk/claude-switcher/main/install.sh | bash
```

安装时会提示：
- 是否删除旧的 `claude-proxy-checker` 脚本
- 是否删除旧的配置文件 `~/.claude_proxy_config`

**手动迁移配置：**
如果保留了旧配置文件，可以手动创建对应的新配置：

```bash
# 查看旧配置
cat ~/.claude_proxy_config

# 创建对应的新配置
claude-switcher  # 选择"创建新配置"
```

## 🛠️ 故障排除

### Claude CLI 未安装
```bash
# 安装Claude CLI
# 访问: https://github.com/anthropics/claude-cli
```

### 配置文件问题
配置文件位于 `~/.claude-switcher/profiles/`，可以手动编辑或删除

### 重新安装
```bash
# 删除旧版本
sudo rm -f /usr/local/bin/claude-switcher

# 重新安装
curl -sSL https://raw.githubusercontent.com/fiftyk/claude-switcher/main/install.sh | bash
```

## 📄 许可证

MIT License

---

**简单、直观、好用！** 🎯