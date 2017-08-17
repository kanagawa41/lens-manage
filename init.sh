#!/bin/sh

# crontab登録
RAILS_ENV=production bundle exec whenever --update-crontab

# 必須フォルダの作成
mkdir -p /home/app/run/
mkdir -p /var/tmp/lens_infos/images/
