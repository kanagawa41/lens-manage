#!/bin/sh

# Railsプロジェクトのデプロイ用シェル
# 対象プロジェクトの一階層に設置する。
# 例)
# プロジェクトパス: /home/test/reails
# 本シェルパス:   /home/test/deploy_XXXX.sh

####################
# Variables
####################
# シェルパス
SCRIPT_DIR=$(cd $(dirname $0); pwd)
# プロジェクト名
PROJECT_NAME=lens-manage
# プロジェクト絶対パス
PROJECT_PATH=$SCRIPT_DIR/lens-manage
BK_PROJECT_PATH=$SCRIPT_DIR/backup/$PROJECT_NAME

BUNDLE_PATH=vendor/bundle
ORG_BUNDLE=$PROJECT_PATH/$BUNDLE_PATH
BK_BUNDLE=$BK_PROJECT_PATH/bundle

ORG_LOG=$PROJECT_PATH/log
BK_LOG=$BK_PROJECT_PATH/log

####################
# Functions
####################
# 存在すれば削除する
ifrm () {
  if [ -e $1 ]; then
    echo "== ${1} exist, delete it. =="
    rm -rf $1
  fi

  return 0 
}

####################
# Varidations
####################
if [ $# -ne 1 ]; then
  echo "引数にinit, app, manageを指定して下さい"
  exit 1
fi

####################
# Main
####################
if [ $1 = "init" ]; then
  ifrm $PROJECT_PATH
  ifrm $BK_PROJECT_PATH
  git clone https://github.com/kanagawa41/$PROJECT_NAME.git
  cd $PROJECT_PATH
  bundle install --deployment --path $BUNDLE_PATH

  mkdir -p $BK_BUNDLE
  cp -r $ORG_BUNDLE $BK_PROJECT_PATH

  mkdir -p $BK_LOG
elif [ $1 = "app" ]; then
  cp -r $ORG_LOG $BK_LOG
  rm -rf $PROJECT_PATH
  git clone https://github.com/kanagawa41/$PROJECT_NAME.git

  # routesを修正
  cp -f $PROJECT_PATH/config routes-app.rb routes.rb

  # バックアップを移行する
  cp -r $BK_BUNDLE/* $ORG_BUNDLE
  cp -r $BK_LOG/* $ORG_LOG

  cd $PROJECT_PATH
  bundle install --deployment --path $BUNDLE_PATH

  # バックアップと差分が発生した場合上書きする
  if [ `diff -qr $ORG_BUNDLE $BK_BUNDLE >/dev/null` ]; then
    rm -rf $BK_BUNDLE
    cp -r $ORG_BUNDLE $BK_PROJECT_PATH
    echo "== Bundle folder has different. Back up bundle folder was updated. =="
  fi

  cd $PROJECT_PATH
  ./up.sh production
elif [ $1 = "manage" ]; then
  echo "使用していません。"
  exit 1
else
  echo "有効な引数ではありません。init, app, manageを指定して下さい"
  exit 1
fi

echo "= Success! ="