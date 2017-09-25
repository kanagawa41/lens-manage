#!/bin/sh

####################
# about
####################
# Railsプロジェクトのデプロイ用シェル
# 対象プロジェクトの一階層に設置する。
# 例)
# プロジェクトパス: /home/test/reails
# 本シェルパス:   /home/test/deploy_XXXX.sh
# 引数)
# 第１：処理内容、第２：プロジェクト名(任意)

####################
# base setting
####################
# シェルパス
SCRIPT_DIR=$(cd $(dirname $0); pwd)
# 実行対象
# キー：引数、値：プロジェクト名
declare -A TYPES=([app]="lens-manage" [manage]="m-lens-manage")
# GITプロジェクト名
GIT_PROJECT_URL=https://github.com/kanagawa41/lens-manage.git

####################
# usage
####################
cmdname=`basename $0`
function usage()
{
  type_str="$(IFS=,; echo "${PROJECTS[*]}")"
  echo "Usage: ${cmdname} TYPE [OPTIONS]"
  echo "  This script is ~."
  echo "TYPE:"
  echo "  using ${type_str}"
  echo "Options:"
  echo "  --init, initialize"
  exit 1
}

####################
# Parameter check
####################
target_project=${TYPES[$1]}
if [ "${target_project}" = "" ]; then
  usage
  exit 1
fi

target_type=$1
shift

declare -i argc=0
declare -a argv=()
while (( $# > 0 ))
do
    case "$1" in
        -*)
            if [[ "$1" =~ '--init' ]]; then
                i_flag='TRUE'
            fi
            shift
            ;;
        # *)
        #     ((++argc))
        #     argv=("${argv[@]}" "$1")
        #     shift
        #     ;;
    esac
done

####################
# Variables
####################
# プロジェクト名
PROJECT_NAME=$target_project

# プロジェクト絶対パス
PROJECT_PATH=$SCRIPT_DIR/$PROJECT_NAME
BK_PROJECT_PATH=$SCRIPT_DIR/backup/$PROJECT_NAME

# バンドルフォルダーパス
BUNDLE_PATH=vendor/bundle
ORG_BUNDLE=$PROJECT_PATH/$BUNDLE_PATH
BK_BUNDLE=$BK_PROJECT_PATH/bundle

# ログフォルダーパス
ORG_LOG=$PROJECT_PATH/log
BK_LOG=$BK_PROJECT_PATH/log

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

####################
# Main
####################
echo "== Start deployment! =="

if [ "${i_flag}" = "TRUE" ]; then
  ifrm $PROJECT_PATH
  ifrm $BK_PROJECT_PATH
  git clone $GIT_PROJECT_URL $PROJECT_NAME
  cd $PROJECT_PATH
  bundle install --deployment --path $BUNDLE_PATH

  mkdir -p $BK_BUNDLE
  cp -r $ORG_BUNDLE $BK_PROJECT_PATH

  mkdir -p $BK_LOG

else
  cp -r $ORG_LOG $BK_LOG
  rm -rf $PROJECT_PATH
  git clone $GIT_PROJECT_URL $PROJECT_NAME

  if [ "${target_type}" = "app" ]; then
    # routesを修正
    cp -f $PROJECT_PATH/config/routes-app.rb $PROJECT_PATH/config/routes.rb
    echo "== Changed routes.rb for app! =="
  fi

  # バックアップを移行する
  cp -r $BK_BUNDLE/* $ORG_BUNDLE
  cp -r $BK_LOG/* $ORG_LOG

  cd $PROJECT_PATH
  bundle install --deployment --path $BUNDLE_PATH

  # バックアップと差分が発生した場合上書きする
  if [ `diff -qr $ORG_BUNDLE $BK_BUNDLE >/dev/null` ]; then
    rm -rf $BK_BUNDLE
    cp -r $ORG_BUNDLE $BK_PROJECT_PATH
    echo "== This folder of bundle is different from the folder of back-up. The folder of back-up was updated latest. =="
  fi

  cd $PROJECT_PATH

  if [ "${target_type}" = "app" ]; then
    ./up.sh production
  else
    ./up.sh production -p 3002 --migrate
  fi

fi

echo "== End deployment with success! =="
