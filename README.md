Takuya Kishira
====

Overview
オールドレンズのデータをスクレイピングにより収集する

## Description
定期的にバッチ実行して、指定のレンズが掲載されているページをスクレイピングする。
取得したデータをCVS形式で保持し登録を行う。

## Demo
NONE

## VS. 
NONE

## Requirement
Ruby on Rails
Capybara
Mariadb
Nginx
Puma

## Usage
writting later

## Install
writting later

## Contribution
1. Fork it ( http://github.com/lens-manage/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## Licence

[MIT]

## Author

[kanagawa41](https://github.com/kanagawa41)

---

## 作成メモ
### 対象URL
* https://spiral-m42.blogspot.jp/p/2017225.html
** http://cameranonaniwa.jp/shop/goods/search.aspx?pb_tree=B0A5&search=x&pb_search=x
** http://www.moritz.co.jp
** http://fotoborse.blog.jp
** http://fotomutori.com
** https://doppietta-tokyo.jp
** http://www.oosawacamera.com
** http://www.akasaka-camera.com
** https://kikuya-camera.shop-pro.jp
** http://flashbackcamera.jp
** http://www.camera-ohnuki.com
** http://www.m-camera.com
** http://www.os-camera.com
** http://www.king-2.co.jp
next
** http://stereocamera.co.jp
  → ステレオカメラ(SRC)
　→スクレイピングしやすそう
　　http://stereocamera.co.jp/?mode=cate&cbid=1205569&csid=3&sort=n
** http://www.nocto.jp
  → ブリコラージュ工房NOCTO(BKN)
  →スクレイピングしにくい
** https://www.rakuten.co.jp/moriyamafarm
  → 森山農園＆カメラ(MAC)
  →対象URLが多い
** http://saito.shiftweb.net/photoshopsaito/index.html
  → フォトショップサイトウ(PSS)
  →数が少ない
** http://www.camerakids.jp
  → カメラキッズ(CKD)
  →数が少ない

### 名前解析
* テキスト解析デモ - 日本語形態素解析: http://riku53.toypark.in/keitaiso/ma_sample.php
** オプション：基本形 全情報
** 指定した品詞のみ出力: 名詞

### DB構成
#### DB(lensdb)

#### SEED
~~~~
$ rails db:seed
#$ rails db:seed:dump
~~~~
　
#### お店情報(m_shop_infos)
* お店名
* URL
~~~~
$ rails g model MShopInfo shop_name:string shop_url:string
#$ rails g scaffold_controller MShopInfo shop_name:string shop_url:string
#$ rails destroy scaffold_controller MShopInfo
~~~~

#### レンズ情報(m_lens_infos)
* レンズ名
* レンズ写真
* 在庫状況
* 値段
* お店ID
* メモ
* メタデータ
~~~~
$ rails g model MLensInfo lens_name:string lens_pic_url:string stock_state:string price:integer m_shop_info:references
~~~~

#### 収集対象(collect_targets)
* お店ID
* 一覧URL
* ページ数
* 実行可否(1:done, 0:yet)
~~~~
$ rails g model CollectTargets m_shop_info:references list_url:string page_num:integer is_done:boolean
#$ rails g scaffold_controller CollectTarget m_shop_info:references list_url:string start_page_num:integer end_page_num:integer
#$ rails destroy scaffold_controller CollectTarget
~~~~

#### 画像(m_images)
* レンズ情報ID
* 保存パス
~~~~
$ rails g model MImages m_lens_info:references path:string
#$ rails g scaffold_controller Mimage m_lens_info:references path:string
#$ rails destroy scaffold_controller Mimage
~~~~

#### 画像(image_download_histories)
* お店ID
* レンズ情報ID
* レンズ画像URL
* HTTPステータス
~~~~
$ rails g model ImageDownloadHistories m_shop_info_id:references m_lens_info_id:references lens_pic_url:string http_status:integer
#$ rails g scaffold_controller ImageDownloadHistory m_shop_info_id:references m_lens_info_id:references lens_pic_url:string http_status:integer
#$ rails destroy scaffold_controller ImageDownloadHistory
~~~~

image_download_histories
 - m_shop_info_id
 - m_lens_info_id
 - lens_pic_url
 - http_status(200等)


#### 収集倉庫(collect_warehouses)
* 収集ID
* 生収集テキスト
~~~~
$ rails g model collectWarehouse m_shop_info:references row_collect_text:string
~~~~

#### 収集結果(collect_results)
* 収集ID
* 結果(1:成功, 0:失敗)
~~~~
$ rails g model CollectResults collect_target:references is_done:boolean
~~~~

#### 検索履歴(search_histories)
* 検索文字
* 検索条件(店名、f値等)
~~~~
$ rails g model search_histories search_char:string search_condition_json:string
~~~~

#### 遷移履歴(transition_histories)
* レンズ情報ID
~~~~
$ rails g model transition_histories m_lens_info:references
~~~~

### 形態素解析
参考
http://riku53.toypark.in/keitaiso/ma_sample.php
　→指定品詞(名詞)
gem
http://kyohei8.hatenablog.com/entry/2013/12/14/125726

