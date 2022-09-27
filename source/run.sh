#! /usr/bin/bash
# Author       : lixiang @ firebolt
# Created Time : 2022-09-06 17:17:38
# Description  : <Why this script>

cd .. ; make html
sudo rsync -avzt --delete build/html/ /var/www/html/xqdocs
