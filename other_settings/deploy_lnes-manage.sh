#!/bin/sh

# Railsプロジェクトのデプロイ用シェル
# 対象プロジェクトの一階層に設置する。
# 例)
# プロジェクトパス: /home/test/reails
# 本シェルパス:   /home/test/deploy_XXXX.sh
# 引数)
# 第１：処理内容、第２：プロジェクト名(任意)

echo "== Start deployment! =="

####################
# Parameter varidations
####################
valid_params () {
  # 引数に配列を受け取るためのおまじない
  local param_1=$1
  shift
  local param_2=($@)

  # if文に[]をつけると意図しない動きになる
  if ! `echo ${param_2[@]} | grep -qw "$param_1"` ; then
    delimiter=", "; str=""; for var in ${param_2[@]}; do str+="${delimiter}'${var}'"; done; str=`echo $str | sed -e "s/^${delimiter}//"`
    echo "有効な引数ではありません。$strから指定して下さい。"
    exit 1
  fi
}

# 実行対象（順番は重要）
DEPS=("init" "app" "manage")
# プロジェクト名（順番は重要）
PROJECTS=("lens-manage" "m-lens-manage")
if [ $# -ne 2 ]; then
  echo "引数に実行タイプ(${DEPS[@]}), プロジェクト名(${PROJECTS[@]})を渡してください。"
  exit 1
fi

valid_params $1 ${DEPS[@]}
valid_params $2 ${PROJECTS[@]}

####################
# Variables
####################
# シェルパス
SCRIPT_DIR=$(cd $(dirname $0); pwd)
# GITプロジェクト名
GIT_PROJECT_URL=https://github.com/kanagawa41/lens-manage.git
# プロジェクト名
PROJECT_NAME=$2

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
if [ $1 = ${DEPS[0]} ]; then
  ifrm $PROJECT_PATH
  ifrm $BK_PROJECT_PATH
  git clone $GIT_PROJECT_URL $PROJECT_NAME
  cd $PROJECT_PATH
  bundle install --deployment --path $BUNDLE_PATH

  mkdir -p $BK_BUNDLE
  cp -r $ORG_BUNDLE $BK_PROJECT_PATH

  mkdir -p $BK_LOG

elif [ $1 = ${DEPS[1]} ] || [ $1 = ${DEPS[2]} ]; then
  cp -r $ORG_LOG $BK_LOG
  rm -rf $PROJECT_PATH
  git clone $GIT_PROJECT_URL $PROJECT_NAME

  if [ $1 = ${DEPS[1]} ]; then
    # routesを修正
    cp -f $PROJECT_PATH/config routes-app.rb routes.rb
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
  ./up.sh $1 production
fi

echo "== Success! =="