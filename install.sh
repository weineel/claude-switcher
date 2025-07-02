#!/bin/bash

# 设置安装目录
INSTALL_DIR="/usr/local/bin"

# 下载脚本
echo "正在下载 Claude Proxy Checker 脚本..."
curl -L https://raw.githubusercontent.com/fiftyk/claude-proxy-checker/main/claude-proxy-checker.sh -o claude-proxy-checker.sh

# 设置权限
chmod +x claude-proxy-checker.sh

# 移动到系统可执行路径
sudo mv claude-proxy-checker.sh "$INSTALL_DIR/claude-proxy-checker"

# 验证安装
if [ -f "$INSTALL_DIR/claude-proxy-checker" ]; then
    echo "安装成功！可以直接运行 claude-proxy-checker 命令"
else
    echo "安装失败"
    exit 1
fi
