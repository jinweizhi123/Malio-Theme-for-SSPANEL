#!/bin/bash

# 切换到 Malio 目录
cd /www/wwwroot/malio

# 克隆 Malio 主题存储库并进行设置
git clone -b malio https://github.com/laoyu1120/Malio-Theme-for-SSPANEL.git tmp && mv tmp/.git . && rm -rf tmp && git reset --hard

# 下载并安装 Composer
wget https://getcomposer.org/installer -O composer.phar
php composer.phar

# 安装依赖项
php composer.phar install

# 复制配置文件
cp config/.malio_config.example.php config/.malio_config.php
cp config/.config.example.php config/.config.php
cp config/.i18n.example.php config/.i18n.php

# 切换回上级目录
cd ../

# 设置权限和所有权
chmod -R 755 malio/
chown -R www:www malio/

# 下载 IP 数据库文件
wget -O /www/wwwroot/malio/storage/qqwry.dat https://github.com/laoyu1120/Malio-Theme-for-SSPANEL/releases/download/qqwry.dat/qqwry.dat
wget -O /www/wwwroot/malio/storage/GeoLite2-City.mmdb https://github.com/laoyu1120/Malio-Theme-for-SSPANEL/releases/download/GeoLite2-City.mmdb/GeoLite2-City.mmdb

# 设置定时任务
crontab -l > temp_cron
echo "0 0 * * * php -n /www/wwwroot/malio/xcat dailyjob" >> temp_cron
echo "*/1 * * * * php /www/wwwroot/malio/xcat checkjob" >> temp_cron
echo "*/1 * * * * php /www/wwwroot/malio/xcat syncnode" >> temp_cron
crontab temp_cron
rm temp_cron
