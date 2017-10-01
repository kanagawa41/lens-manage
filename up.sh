#!/bin/sh
####################
# 指定した環境に即してプロジェクトを起動する。
####################

####################
# base setting
####################
# シェルパス
SCRIPT_DIR=$(cd $(dirname $0); pwd)
ENVS=("test" "development" "production")

####################
# usage
####################
cmdname=`basename $0`
function usage()
{
  env_str="$(IFS=,; echo "${ENVS[*]}")"
  echo "Usage: ${cmdname} ENV [OPTIONS]"
  echo "  This script is ~."
  echo "ENV:"
  echo "  using ${env_str}"
  echo "Options:"
  echo "  -p, port(e.g. 3000)"
  echo "  --migrate, If ENV was production, execute 'rails db:migrate'"
  exit 1
}

####################
# Parameter varidations
####################
declare -i argc=0
declare -a argv=()

if ! `echo ${ENVS[@]} | grep -q "$1"` ; then
  usage
  exit 1
fi
target_env=$1
shift

while (( $# > 0 ))
do
    case "$1" in
        -*)
            if [[ "$1" =~ '-p' ]]; then
                p_flag='TRUE'
            fi
            if [[ "$1" =~ '--migrate' ]]; then
                m_flag='TRUE'
            fi
            shift
            ;;
        *)
            ((++argc))
            argv=("${argv[@]}" "$1")
            shift
            ;;
    esac
done


####################
# Variables
####################
# プロジェクト名
PROJECT_NAME=`echo ${SCRIPT_DIR} | awk -F "/" '{ print $NF }'`
# ポート
if [ "${p_flag}" = "TRUE" ]; then
  PORT="-p ${argv[0]}"
else
  PORT=""
fi

####################
# Functions
####################
# nothing


####################
# Main
####################
echo "== Start stand up! =="

if [ "${target_env}" = "test" ]; then
  echo "== rails =="
  ps aux | grep -w "\[$PROJECT_NAME\]" | grep -v grep | awk '{ print "kill -9", $2 }' | sh
  RAILS_ENV=${target_env} bundle exec rails assets:clean
  rm -rf public/assets

  RAILS_ENV=${target_env} nohup bundle exec rails s -b 0.0.0.0 $PORT &

  if [ ! $? = 0 ] ; then echo "FAILD: set up rails."; exit 1; fi

  SELF_IP=`hostname -I | cut -f2 -d' '` #自身のＩＰを取得
  if [ -n "$PORT" ]; then
    echo "IP is $SELF_IP"
  fi

elif [ "${target_env}" = "development" ]; then
  ps aux | grep -w "\[$PROJECT_NAME\]" | grep -v grep | awk '{ print "kill -9", $2 }' | sh
  bundle exec rails assets:clean RAILS_ENV=${target_env} # クリーンしても直近３バージョンは保持される
  bundle exec rails assets:precompile RAILS_ENV=${target_env}
  RAILS_ENV=${target_env} nohup bundle exec puma -w 4 $PORT &

  if [ ! $? = 0 ] ; then echo "FAILD: set up rails."; exit 1; fi

elif [ "${target_env}" = "production" ]; then
  cat /home/app/run/$PROJECT_NAME.pid | awk '{ print "kill -9", $0 }' | sh
  bundle exec rails assets:clean RAILS_ENV=${target_env} # クリーンしても直近３バージョンは保持される
  bundle exec rails assets:precompile RAILS_ENV=${target_env}
  if [ "${m_flag}" = "TRUE" ]; then
    bundle exec rails db:migrate RAILS_ENV=${target_env}
    bundle exec rails db:migrate:status RAILS_ENV=${target_env}
  fi
  RAILS_ENV=${target_env} bundle exec whenever --update-crontab
  # ポートを指定するとsockが使用できない
  SECRET_KEY_BASE=`bundle exec rails secret` RAILS_SERVE_STATIC_FILES=true RAILS_ENV=${target_env} nohup bundle exec puma -w 4 $PORT &

  if [ ! $? = 0 ] ; then echo "FAILD: set up rails."; exit 1; fi

fi
echo "== Stand up as ${target_env} =="
