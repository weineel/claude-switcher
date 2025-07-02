#!/bin/bash

# 函数：获取出口IP地址
get_public_ip() {
    local ip=$(curl -s https://api.ipify.org?format=json | grep -o '"ip":"[^"]*"' | awk -F'"' '{print $4}')
    echo "$ip"
}

# 检测是否提供了IP地址
if [ -z "$1" ]; then
    echo "未提供IP地址，正在检测您的出口IP..."
    IP_ADDRESS=$(get_public_ip)
    echo "检测到的出口IP: $IP_ADDRESS"
else
    IP_ADDRESS=$1
fi

# 使用ip-api.com查询详细的IP地址信息
response=$(curl -s "http://ip-api.com/json/$IP_ADDRESS?fields=status,message,country,countryCode,regionName,city,isp,org,as,query")

# 使用grep和awk解析JSON
status=$(echo "$response" | grep -o '"status":"[^"]*"' | awk -F'"' '{print $4}')
country=$(echo "$response" | grep -o '"country":"[^"]*"' | awk -F'"' '{print $4}')
countryCode=$(echo "$response" | grep -o '"countryCode":"[^"]*"' | awk -F'"' '{print $4}')
region=$(echo "$response" | grep -o '"regionName":"[^"]*"' | awk -F'"' '{print $4}')
city=$(echo "$response" | grep -o '"city":"[^"]*"' | awk -F'"' '{print $4}')
isp=$(echo "$response" | grep -o '"isp":"[^"]*"' | awk -F'"' '{print $4}')
org=$(echo "$response" | grep -o '"org":"[^"]*"' | awk -F'"' '{print $4}')
as=$(echo "$response" | grep -o '"as":"[^"]*"' | awk -F'"' '{print $4}')
query=$(echo "$response" | grep -o '"query":"[^"]*"' | awk -F'"' '{print $4}')

# 检查查询是否成功
if [ "$status" != "success" ]; then
    error_message=$(echo "$response" | grep -o '"message":"[^"]*"' | awk -F'"' '{print $4}')
    echo "查询失败: $error_message"
    exit 1
fi

# 显示详细信息
echo "──────────────────────────────"
echo "IP地址:        $query"
echo "国家/地区:     $country ($countryCode)"
echo "地区:          $region"
echo "城市:          $city"
echo "ISP提供商:     $isp"
echo "组织机构:      $org"
echo "AS编号和信息:  $as"
echo "──────────────────────────────"

# 检查国家是否是美国
if [ "$countryCode" = "US" ]; then
    echo "✓ 该IP地址位于美国"
    echo "请选择操作："
    echo "1) 执行 claude 命令"
    echo "2) 退出"
    read -p "请输入选项 [1-2]: " choice
    case "$choice" in
        1)
            echo "正在执行 claude 命令..."
            claude
            exit 0
            ;;
        2)
            echo "已退出。"
            exit 0
            ;;
        *)
            echo "无效选项，已退出。"
            exit 0
            ;;
    esac
else
    echo "✗ 该IP地址不在美国"
    exit 2
fi