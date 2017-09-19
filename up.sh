#!/bin/sh

echo "== Start stand up! =="

####################
# Parameter varidations
####################
valid_params () {
  # 引数に配列を受け取るためのおまじない
  local param_1=$1
  shift
  local param_2=($@)

  # if文に[]をつけると意図しない動きになる
  if ! `echo $param_2[@] | grep -qw "$param_1"` ; then
    SPECIFIC_STR=$(IFS=,; echo "${param_2[*]}")
    echo "有効な引数ではありません！'$SPECIFIC_STR'から指定して下さい。"
    exit 1
  fi
}

if [ $# -ne 1 ]; then
  echo "引数に'環境名'を渡してください。"
  exit 1
fi

# 実行環境変数（順番は重要）
ENVS=("local" "development" "production")
valid_params $1 ${ENVS[@]}


####################
# Variables
####################
# シェルパス
SCRIPT_DIR=$(cd $(dirname $0); pwd)
# プロジェクト名
PROJECT_NAME=`echo ${SCRIPT_DIR} | awk -F "/" '{ print $NF }'`


####################
# Functions
####################
# nothing


####################
# Main
####################
if [ $1 = ${ENVS[0]} ]; then
  echo "== rails =="
  ps aux | grep -w "[$PROJECT_NAME]" | grep -v grep | awk '{ print "kill -9", $2 }' | sh
  PORT=3001
  nohup bundle exec rails s -b 0.0.0.0 -p $PORT &

  if [ $? -ne 0 ] ; then
    echo "FAILD: set up rails."
    exit 1
  fi

  SELF_IP=`hostname -I | cut -f2 -d' '` #自身のＩＰを取得
  echo "http://$SELF_IP:$PORT/"
  echo "== Stand up as ${ENVS[0]} =="
elif [ $1 = ${ENVS[1]} ]; then
  ps aux | grep -w "[$PROJECT_NAME]" | grep -v grep | awk '{ print "kill -9", $2 }' | sh
  nohup bundle exec puma -w 4 &

  if [ $? -ne 0 ] ; then
    echo "FAILD: set up rails."
    exit 1
  fi

  echo "== Stand up as ${ENVS[1]} =="
elif [ $1 = ${ENVS[2]} ]; then
  cat /home/app/run/$PROJECT_NAME.pid | awk '{ print "kill -9", $0 }' | sh
  bundle exec rails assets:clean RAILS_ENV=production # クリーンしても直近３バージョンは保持される
  bundle exec rails assets:precompile RAILS_ENV=production
  RAILS_ENV=production bundle exec whenever --update-crontab
  SECRET_KEY_BASE=`bundle exec rails secret` RAILS_SERVE_STATIC_FILES=true RAILS_ENV=production nohup bundle exec puma -w 4 &

  if [ $? -ne 0 ] ; then
    echo "FAILD: set up rails."
    exit 1
  fi

  echo "== Stand up as ${ENVS[2]} =="
fi
