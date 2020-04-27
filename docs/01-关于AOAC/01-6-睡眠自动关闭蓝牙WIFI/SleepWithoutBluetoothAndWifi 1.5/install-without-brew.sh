#!/bin/bash

echo  -e "\033[36m [Info] \033[0m蓝牙控制服务安装中..."
echo  -e "\033[36m [Info] \033[0m我们需要root权限来修改一些配置文件，请授权..."
#安装blueutil
sudo cp ./blueutil/2.5.1/bin/blueutil  /usr/local/bin/
echo -e "\033[32m [OK] \033[0m蓝牙控制服务安装完成..."

echo  -e "\033[36m [Info] \033[0m睡眠监听服务安装中..."
#安装sleepwatcher
sudo mkdir -p /usr/local/sbin /usr/local/share/man/man8
sudo cp ./sleepwatcher/2.2.1/sbin/sleepwatcher /usr/local/sbin
sudo cp ./sleepwatcher/2.2.1/share/man/man8/sleepwatcher.8 /usr/local/share/man/man8
sudo cp ./sleepwatcher/2.2.1/de.bernhard-baehr.sleepwatcher-20compatibility-localuser.plist /Library/LaunchDaemons/de.bernhard-baehr.sleepwatcher-20compatibility-localuser.plist 
echo -e "\033[32m [OK] \033[0m睡眠监听服务安装完成..."
#后续操作
cd ~
sudo rm -rf .sleep
sudo rm -rf .wakeup
touch .sleep
touch .wakeup
sudo chmod 777 .sleep
sudo chmod 777 .wakeup

cat>.sleep<<EOF
/usr/local/bin/blueutil -p 0
networksetup -setairportpower en0 off
EOF
cat>.wakeup<<EOF
/usr/local/bin/blueutil -p 1
until networksetup -getairportpower en0 | grep On > /dev/null
do
	networksetup -setairportpower en0 on
	sleep 1
done
EOF
#启动服务
sudo launchctl load /Library/LaunchDaemons/de.bernhard-baehr.sleepwatcher-20compatibility-localuser.plist

echo -e "\033[32m [OK] \033[0m服务已启动，请尝试睡眠..."