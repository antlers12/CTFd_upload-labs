#!/bin/sh

# 重启服务
service apache2 restart

# 设置动态flag，后面会详细解释
sed -i "s/Antlers12/$FLAG/g" /flag
export FLAG=not_flag
FLAG=not_flag

# 永不退出的进程
tail -f /var/log/1.txt
