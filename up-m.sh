#!/bin/sh
PORT=54310

ps aux | grep m-lens-manage | grep -v grep | awk '{ print "kill -9", $2 }' | sh
nohup bundle exec rails s -b 0.0.0.0 -p $PORT &

echo "== open as manage =="
