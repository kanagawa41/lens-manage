#!/bin/sh

if [ $# -ne 1 ]; then
  echo "引数にlocal, development, productionを指定して下さい"
  exit 1
fi

if [ $1 = "local" ]; then
  IP_ADD=192.168.33.10

  ps aux | grep lens-manage | grep -v grep | awk '{ print "kill -9", $2 }' | sh
  nohup bundle exec rails s -b 0.0.0.0 &

  echo "== open as local =="
  echo "http://$IP_ADD:3000/"
elif [ $1 = "development" ]; then
  ps aux | grep lens-manage | grep -v grep | awk '{ print "kill -9", $2 }' | sh
  nohup bundle exec puma -w 4 &

  echo "== open as development =="
elif [ $1 = "production" ]; then
  cat /home/app/run/lens-manage.pid | awk '{ print "kill -9", $0 }' | sh
  # 直近３バージョンは保持する仕様
  bundle exec rails assets:clean RAILS_ENV=production
  bundle exec rails assets:precompile RAILS_ENV=production
  SECRET_KEY_BASE=`bundle exec rails secret` RAILS_SERVE_STATIC_FILES=true RAILS_ENV=production nohup bundle exec puma -w 4 &

  echo "== open as production =="
else
  echo "有効な引数ではありません。local, development, productionを指定して下さい"
  exit 1
fi
