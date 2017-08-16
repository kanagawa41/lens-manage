#!/bin/sh

IP_ADD=192.168.33.10

if [ $# -ne 1 ]; then
  echo "引数にlocal, development, productionを指定して下さい"
  exit 1
fi

if [ $1 = "local" ]; then
  ps aux | grep lens-manage | grep -v grep | awk '{ print "kill -9", $2 }' | sh
  nohup rails s -b 0.0.0.0 &

  echo "== open as local =="
  echo "http://$IP_ADD:3000/"
elif [ $1 = "development" ]; then
  ps aux | grep lens-manage | grep -v grep | awk '{ print "kill -9", $2 }' | sh
  nohup puma -w 4 &

  echo "== open as development =="
elif [ $1 = "production" ]; then
  cat /home/app/run/lens-manage.pid | awk '{ print "kill -9", $0 }' | sh
  rails assets:precompile RAILS_ENV=production
  SECRET_KEY_BASE=`rails secret` RAILS_SERVE_STATIC_FILES=true RAILS_ENV=production nohup puma -w 4 &
  #RAILS_SERVE_STATIC_FILES=true RAILS_ENV=production puma -w 4 &

  echo "== open as production =="
else
  echo "有効な引数ではありません。local, development, productionを指定して下さい"
  exit 1
fi

