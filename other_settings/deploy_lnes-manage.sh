#!/bin/sh

# デプロイ用シェル
# /home/app

PROJECT_NAME=lens-manage

if [ $# -ne 1 ]; then
  echo "引数にinit, app, manageを指定して下さい"
  exit 1
fi

if [ $1 = "init" ]; then
  git clone https://github.com/kanagawa41/$PROJECT_NAME.git
  cd $PROJECT_NAME
  bundle install --path vendor/bundle
  cd ../
  mkdir -p vendors/$PROJECT_NAME
  cp -r lens-manage/vendor/bundle vendors/$PROJECT_NAME
elif [ $1 = "app" ]; then
  rm -rf $PROJECT_NAME
  git clone https://github.com/kanagawa41/$PROJECT_NAME.git
  cp -r vendors/$PROJECT_NAME/bundle lens-manage/vendor
  cd $PROJECT_NAME
  bundle install --path vendor/bundle
  ./up.sh production
elif [ $1 = "manage" ]; then
  rm -rf $PROJECT_NAME
  git clone https://github.com/kanagawa41/$PROJECT_NAME.git
  cp -r vendors/$PROJECT_NAME/bundle lens-manage/vendor
  cd $PROJECT_NAME
  bundle install --path vendor/bundle
else
  echo "有効な引数ではありません。init, app, manageを指定して下さい"
  exit 1
fi
