#!/bin/bash

# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 代理设置
DEFAULT_PROXY="http://127.0.0.1:7890"
ORIGINAL_HTTP_PROXY=""
ORIGINAL_HTTPS_PROXY=""

# 检查必要的命令是否存在
check_dependencies() {
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}错误: curl 未安装${NC}"
        echo -e "\n请安装curl:"
        echo "brew install curl"
        exit 1
    fi
}

# 保存原始代理设置
save_original_proxy() {
    ORIGINAL_HTTP_PROXY=$http_proxy
    ORIGINAL_HTTPS_PROXY=$https_proxy
}

# 恢复原始代理设置
restore_original_proxy() {
    export http_proxy=$ORIGINAL_HTTP_PROXY
    export https_proxy=$ORIGINAL_HTTPS_PROXY
}

# 设置代理
set_proxy() {
    local proxy=${1:-$DEFAULT_PROXY}
    echo -e "${YELLOW}正在设置代理: $proxy${NC}"
    export http_proxy=$proxy
    export https_proxy=$proxy
}

# 检查代理是否可用
check_proxy() {
    local test_url="http://www.google.com"
    if curl --connect-timeout 5 -s "$test_url" > /dev/null; then
        echo -e "${GREEN}代理连接成功${NC}"
        return 0
    else
        echo -e "${RED}代理连接失败${NC}"
        return 1
    fi
}

# 从JSON响应中提取字段值
parse_json_field() {
    local json="$1"
    local field="$2"
    echo "$json" | sed -n "s/.*\"$field\":\"\([^\"]*\)\".*/\1/p"
}

# 获取公网IP和地理位置信息
get_ip_location() {
    echo -e "${YELLOW}正在获取IP地理位置信息...${NC}"
    
    # 使用ip-api.com服务获取IP地理位置信息
    local response
    response=$(curl -s "http://ip-api.com/json/?fields=status,message,country,countryCode,regionName,city")
    
    if [ -z "$response" ]; then
        echo -e "${RED}错误: 无法获取IP地理位置信息${NC}"
        return 2
    fi
    
    # 检查API响应状态
    local status
    status=$(echo "$response" | sed -n 's/.*"status":"\([^"]*\)".*/\1/p')
    if [ "$status" = "fail" ]; then
        local error_msg
        error_msg=$(echo "$response" | sed -n 's/.*"message":"\([^"]*\)".*/\1/p')
        echo -e "${RED}错误: $error_msg${NC}"
        return 2
    fi
    
    # 解析JSON响应
    local country_code
    local country_name
    local region
    local city
    
    country_code=$(echo "$response" | sed -n 's/.*"countryCode":"\([^"]*\)".*/\1/p')
    country_name=$(echo "$response" | sed -n 's/.*"country":"\([^"]*\)".*/\1/p')
    region=$(echo "$response" | sed -n 's/.*"regionName":"\([^"]*\)".*/\1/p')
    city=$(echo "$response" | sed -n 's/.*"city":"\([^"]*\)".*/\1/p')
    
    # 检查是否成功获取到国家代码
    if [ -z "$country_code" ]; then
        echo -e "${RED}错误: 无法解析地理位置信息${NC}"
        echo -e "API响应: $response"
        return 2
    fi
    
    echo -e "\n当前位置信息:"
    echo -e "国家: ${GREEN}$country_name${NC}"
    echo -e "地区: ${GREEN}$region${NC}"
    echo -e "城市: ${GREEN}$city${NC}"
    
    # 检查是否在美国
    if [ "$country_code" = "US" ]; then
        return 0
    else
        return 1
    fi
}

# 启动Claude的函数
start_claude() {
    echo -e "\n${GREEN}正在启动Claude...${NC}"
    # 这里替换为实际启动Claude的命令
    claude
}

# 主函数
main() {
    # 检查依赖
    check_dependencies
    
    # 保存原始代理设置
    save_original_proxy
    
    # 获取IP位置信息
    get_ip_location
    local location_status=$?
    
    # 如果不在美国，尝试设置代理
    if [ $location_status -eq 1 ]; then
        echo -e "\n${YELLOW}当前IP位置不在美国，尝试设置代理...${NC}"
        
        # 询问用户是否要设置自定义代理
        echo -e "\n${YELLOW}请选择代理设置方式:${NC}"
        echo "1) 使用默认代理 ($DEFAULT_PROXY)"
        echo "2) 输入自定义代理"
        echo "3) 退出程序"
        read -r -p "请选择 [1-3] (默认: 1): " choice
        
        case ${choice:-1} in
            1)
                set_proxy
                ;;
            2)
                echo -e "\n请输入代理地址 (格式: http://地址:端口):"
                read -r custom_proxy
                set_proxy "$custom_proxy"
                ;;
            3)
                echo -e "${YELLOW}程序已退出${NC}"
                restore_original_proxy
                exit 0
                ;;
            *)
                echo -e "${RED}无效的选择${NC}"
                restore_original_proxy
                exit 1
                ;;
        esac
        
        # 检查代理是否可用
        if ! check_proxy; then
            echo -e "${RED}代理设置失败，程序退出${NC}"
            restore_original_proxy
            exit 1
        fi
        
        # 使用代理后再次检查位置
        echo -e "\n${YELLOW}正在使用代理重新检查位置...${NC}"
        get_ip_location
        location_status=$?
    fi
    
    # 根据最终的位置状态处理
    if [ $location_status -eq 0 ]; then
        echo -e "\n${GREEN}检测到当前IP位置在美国${NC}"
        
        # 询问是否启动Claude
        echo -e "\n${YELLOW}请选择操作:${NC}"
        echo "1) 启动Claude"
        echo "2) 退出"
        read -r -p "请选择 [1-2] (默认: 1): " choice
        
        case ${choice:-1} in
            1)
                start_claude
                ;;
            2)
                echo -e "${YELLOW}已取消启动Claude${NC}"
                ;;
            *)
                echo -e "${RED}无效的选择${NC}"
                ;;
        esac
    elif [ $location_status -eq 1 ]; then
        echo -e "\n${RED}即使使用代理，IP位置仍然不在美国${NC}"
    else
        echo -e "\n${RED}获取位置信息失败${NC}"
    fi
    
    # 恢复原始代理设置
    restore_original_proxy
}

# 执行主函数
main 