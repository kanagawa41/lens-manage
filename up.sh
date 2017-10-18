#!/bin/sh
####################
# 指定した環境に即してプロジェクトを起動する。
####################

####################
# base setting
####################
# シェルパス
SCRIPT_DIR=$(cd $(dirname $0); pwd)
ENVS=("dev" "test" "production")

####################
# usage
####################
cmdname=`basename $0`
function usage()
{
  env_str="$(IFS=,; echo "${ENVS[*]}")"
  echo "Usage: ${cmdname} ENV [OPTIONS]"
  echo ""
  echo "ENV:"
  echo "  using ${env_str}."
  echo ""
  echo "Options:"
  echo "  -p, Server port(e.g. 3000)."
  echo "  --migrate, If ENV was production, execute 'rails db:migrate'."
  echo "  --clean, Execute 'rails assets:clean'."
  echo "  --nokill, Don't kill process of server ahead of up it."
  echo ""
  echo "Examples:"
  echo "  up.sh dev"
  echo "  up.sh dev -p 3000 --migrate --clean --nokill"
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
            if [[ "$1" =~ '--clean' ]]; then
                c_flag='TRUE'
            fi
            if [[ "$1" =~ '--nokill' ]]; then
                nk_flag='TRUE'
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
UP_LOG="_up.log"

####################
# Functions
####################
# 存在すれば削除する
ifrm () {
  if [ -e $1 ]; then
    echo "== ${1} exist and delete it. =="
    rm -rf $1
  fi
}

# タイトルメッセージを出力
putst () {
  if [ "${1}" = "" ]; then
    echo ""
  else
    echo "== ${1} =="
  fi
}
# インフォメッセージを出力
putsi () {
  if [ "${1}" = "" ]; then
    echo ""
  else
    echo "==> ${1}"
  fi
}
# 処理終了を出力
putsd () {
  putsi "done."
}
# サーバープロセスをkillする。方法は二つ(1.pidを確認 2.動作しているプロセスを指定文字でグレップ)
# 引数: pidパス、プロジェクト名
kills () {
  if [ "${nk_flag}" = "TRUE" ]; then
    putsi "Not kill."
    return 0
  fi

  if [ -e $1 ]; then
    kill `cat "${1}"`
    putsi "The way of pid."
    return 0
  fi

  psinfo=`ps aux | grep -w $2 | grep -v grep`
    if [ ! "${psinfo}" = "" ]; then
    # FIXME: 実行結果を渡そうとするとエラーが発生する
    ps aux | grep -w $2 | grep -v grep | awk '{ print "kill -9", $2 }' | sh
    putsi "The way of ps."
    return 0
  fi

  putsi "Not kill."
}

####################
# Main
####################
putst "**Start stand up**"

if [ "${target_env}" = "dev" ]; then
  target_env=development

  putst "Process kill"
  kills "tmp/pids/server.pid" "puma"
  putsd

  if [ "${c_flag}" = "TRUE" ]; then
    putst "Clean assets"
    bundle exec rails tmp:cache:clear RAILS_ENV=${target_env}
    bundle exec rails assets:clobber RAILS_ENV=${target_env}
    putsd
  fi

  putst "Up server"
  # 「-d」でデーモン化すると、css、jsの読み込みがされなくなる(precompileすれば大丈夫)
  bundle exec rails s -b 0.0.0.0 $PORT -e ${target_env} > $UP_LOG 2>&1 &

  if [ ! $? = 0 ] ; then putsi "FAILD: set up rails."; exit 1; fi

  SELF_IP=`hostname -I | cut -f2 -d' '` #自身のＩＰを取得
  if [ "${PORT}" = "" ]; then
    putsi "IP is $SELF_IP"
  else
    putsi "IP is $SELF_IP:${argv[0]}"
  fi
  putsd

elif [ "${target_env}" = "test" ]; then
  target_env=test

  putst "Process kill"
  kills "/home/app/run/$PROJECT_NAME.pid" "\[${PROJECT_NAME}\]"
  putsd

  if [ "${c_flag}" = "TRUE" ]; then
    putst "Clean assets"
    bundle exec rails assets:clobber RAILS_ENV=${target_env} # クリーンしても直近３バージョンは保持される
    putsd
  fi

  putst "Assets compile"
  bundle exec rails assets:precompile RAILS_ENV=${target_env}
  putsd

  putst "Up server"
  RAILS_ENV=${target_env} bundle exec puma -w 4 $PORT -d > $UP_LOG 2>&1
  if [ ! $? = 0 ] ; then putsi "FAILD: set up rails."; exit 1; fi
  putsd

elif [ "${target_env}" = "production" ]; then
  target_env=production

  putst "Process kill"
  kills "/home/app/run/$PROJECT_NAME.pid" "\[${PROJECT_NAME}\]"
  putsd

  if [ "${c_flag}" = "TRUE" ]; then
    putst "Clean assets"
    bundle exec rails assets:clobber RAILS_ENV=${target_env} # クリーンしても直近３バージョンは保持される
    putsd
  fi

  if [ "${m_flag}" = "TRUE" ]; then
    putst "Migration"
    bundle exec rails db:migrate RAILS_ENV=${target_env}
    bundle exec rails db:migrate:status RAILS_ENV=${target_env}
    putsd
  fi

  putst "Assets compile"
  bundle exec rails assets:precompile RAILS_ENV=${target_env}
  putsd

  putst "Update crontab"
  RAILS_ENV=${target_env} bundle exec whenever --update-crontab
  putsd

  putst "Up server"
  # ポートを指定するとsockが使用できない
  SECRET_KEY_BASE=`bundle exec rails secret` RAILS_SERVE_STATIC_FILES=true RAILS_ENV=${target_env} bundle exec puma -w 4 $PORT -d > $UP_LOG 2>&1
  if [ ! $? = 0 ] ; then putsi "FAILD: set up rails."; exit 1; fi
  putsd

fi

putst "Stand up as ${target_env}"