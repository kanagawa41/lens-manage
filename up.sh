#!/bin/sh

####################
# Variables
####################
# シェルパス
SCRIPT_DIR=$(cd $(dirname $0); pwd)
# プロジェクト名
PROJECT_NAME=lens-manage
# 実行環境変数（順番は重要）
ENVS=("local" "development" "production")
ENVS_STR=$(IFS=,; echo "${ENVS[*]}")

####################
# Parameter varidations
####################
if [ $# -ne 1 ]; then
  echo "引数に$ENVS_STRを指定して下さい"
  exit 1
fi

# if文に[]をつけると意図しない動きになる
if ! `echo ${ENVS[@]} | grep -qw "$1"` ; then
  echo "有効な引数ではありません。$ENVS_STRを指定して下さい"
  exit 1
fi

####################
# Main
####################
if [ $1 = ${ENVS[0]} ]; then
  ps aux | grep -w "[$PROJECT_NAME]" | grep -v grep | awk '{ print "kill -9", $2 }' | sh
  PORT=3001
  nohup bundle exec rails s -b 0.0.0.0 -p $PORT &

  SELF_IP=`hostname -I | cut -f2 -d' '` #自身のＩＰを取得
  echo "http://$SELF_IP:$PORT/"
  echo "== Stand up as ${ENVS[0]} =="
elif [ $1 = ${ENVS[1]} ]; then
  ps aux | grep -w "[$PROJECT_NAME]" | grep -v grep | awk '{ print "kill -9", $2 }' | sh
  nohup bundle exec puma -w 4 &

  echo "== Stand up as ${ENVS[1]} =="
elif [ $1 = ${ENVS[2]} ]; then
  cat /home/app/run/$PROJECT_NAME.pid | awk '{ print "kill -9", $0 }' | sh
  bundle exec rails assets:clean RAILS_ENV=production # クリーンしても直近３バージョンは保持される
  bundle exec rails assets:precompile RAILS_ENV=production
  RAILS_ENV=production bundle exec whenever --update-crontab
  SECRET_KEY_BASE=`bundle exec rails secret` RAILS_SERVE_STATIC_FILES=true RAILS_ENV=production nohup bundle exec puma -w 4 &

  echo "== Stand up as ${ENVS[2]} =="
fi
