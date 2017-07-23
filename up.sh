#!/bin/sh

IP_ADD=192.168.33.10

ps aux | grep mer-manage | grep -v grep | awk '{ print "kill -9", $2 }' | sh
nohup rails s -b 0.0.0.0 &

echo "== open manage =="
echo "http://$IP_ADD:3000/"

