namespace :mytest do
  desc "テスト"

  # 名前を一括変換する
  task exec14: :environment do
    require 'nkf'

    # 統一性が取れるように名前に変換をかける
    def convert_unity_name(lens_name)
      return nil unless lens_name.present?

      convert_word = lens_name

      # 英数を全角から半角へ変換
      convert_word = convert_word.tr('０-９', '0-9')
      # カタカナを半角から全角へ変換
      convert_word = NKF.nkf('-wX', convert_word)
      # アルファベットと記号を半角から全角へ変換
      convert_word = NKF.nkf('-wZ0', convert_word)
      # 小文字へ変換
      convert_word = convert_word.downcase
      # 全角空白を半角へ変換
      convert_word = NKF.nkf('-wZ1', convert_word)
    end

    MLensInfo.all.each do |r|
      r.lens_name = convert_unity_name r.lens_name

      unless r.save
        pp "セーブエラー：#{r.lens_name}"
      end
    end
  end

  # Googleの検索検証
  task exec13: :environment do
    # words = "アリフレックスマウント（16mm） COOKE KINETAL 12.5mm/f1.8 後キャップ、フィルター付 ペンタックスQにオススメです レンズ,pentax q,q,pentax,...,COOKE KINETAL,Arriflexマウント,付き,レンズ,レンズ,オススメです,レンズ,16mm,レンズです,Pentax,キャップ,レンズ,...,です,フィルター,COOKE KINETAL,Arriflexマウント,付き,レンズ,PENTAX Q,レンズ,です,レンズ,オススメです,レンズ,...,です,キャップ,ペンタックスQ,レンズ,ARRIFLEXマウント,PENTAX レンズキャップ,Qマウントレンズ,PENTAX,レンズキャップ,Qマウントレンズ,レンズキャップ,マウントレンズ,レンズ,キャップ,です,フィルターPENTAX Q,おすすめ,レンズ,付け,マウント,mount,マウントレンズ,PENTAX Qにオススメです,マウントレンズ,16mm,ペンタックスQにオススメです,マウントレンズ,後,キャップ,マウント,レンズ,12.5mm/f1.8 後キャップ,PENTAX Q,マウント,レンズ,...,PENTAX Q,レンズ,マウント,16mm,レンズ,マウント,PENTAX Q,pentaxq,...,レンズ,PENTAX Q,です,PENTAX Q,マウントレンズ,レンズフィルター,レンズ,レンズ,レンズ,キャップ,レンズ,レンズ,です,Arriflex,マウント,Cooke,おすすめ,マウント キャップ,ペンタックスQ,レンズ,おすすめ,アリフレックスマウント（16mm） COOKE KINETAL 12.5mm/f1.8 後キャップ、フィルター付 ペンタックスQにオススメです レンズ"
    # words = "レンズ,C,マウントレンズ,50mm,f1,9,後キャップ,フード付き,Cマウントレンズ,マイクロフォー,サーズ,Ｃマウントレンズ,Kodak Cine Ektar,オススメです,Cマウントレンズ Kodak Cine Ektar 50mm/f1.9 後キャップ、フード付 マイクロフォーサーズ機にオススメです レンズ,C,マウント,c,レンズ,f1,9,オススメです,Cマウントレンズ,50mm,f1,フード,後キャップ,マイクロフォーサーズ機,オススメ,です,Cine Ektar,9,レンズ,cc,...,お薦め,レンズ,マイクロ,フォーサーズ,Ｆ1,9,レンズ,コダック,Ｃ,マウント,付き,レンズ,...,レンズ,レンズ,50mm,F1,Cマウント,KODAK CINE EKTAR,F1,F1,9,キャップ,マイクロフォー,サーズ,レンズです,フード,です,レンズ,...,Cマウントレンズ,マイクロフォーサーズ,です,F1,9,コダック,レンズ,Cマウント,レンズ,F1,Cine EKTAR,F1,です,50mm,F1,キャップ,フード付,レンズ,レンズ,...,Cマウント,レンズキャップ,キャップ,レンズフード,F1,9,です,キャップ,マイクロフォーサーズ,レンズ,F1,KODAK CINE EKTAR,F1,レンズ,...,レンズ,レンズ,マイクロフォーサーズ,レンズ,レンズ,Ｃマウントレンズ,レンズ,です,レンズキャップ,キャップ,レンズ,KODAK CINE,F1,9,Cine,レンズ,50mm,です,F1,9,コダックF1,レンズ,付きです,9,レンズ,フード,マイクロフォーサーズ,レンズ,Ｃマウント,です,50mm F1,F1,9,です,...,付け,です,マウント,レンズです,F1,レンズ,レンズ,マイクロフォーサーズ,Cine Ektar です,9,Cマウントレンズ Kodak Cine Ektar 50mm/f1.9 後キャップ、フード付 マイクロフォーサーズ機にオススメです レンズ,,1"
    # words = "HELIOS-40 85mm/f1.5 初期シルバー M42マウント改造 レンズ,HELIOS,40 85mm,f1,5 初期シルバー M42マウント改造,レンズ,レンズ,M42マウント,改造,HELIOS,40 85mm,f1,5 初期シルバー M42マウント改造,f1,5,レンズ,レンズ,M42,マウント,改造レンズ,レンズ,HELIOS,40,85mm,f1,5,レンズ,HELIOS,40 85mm,f1,5 初期シルバー M42マウント改造,改造レンズ,レンズ,レンズ,レンズ,初期シルバー M42マウント改造,HELIOS,40,85mm,f1,5,Helios 40,85mm m42,レンズ,5,Helios,85mm,レンズ,5,Helios 40,m42,レンズ,レンズ,Helios 40,マウント,Helios 40,M42 85mm F1,5,レンズ,silver,初期,HELIOS,40,85mm F1,5,M42マウント,...,HELIOS,40,85mm F1,5,M42マウント,初期,M42マウント,レンズ,ヘリオス,ヘリオス,改造,HELIOS,40,85mm F1,5,M42マウント,初期,レンズ,シルバー,HELIOS,M42 MOUNT,m42,helios,m42,m42,...,HELIOS,M42,M42,M42,M42,レンズ,初期,シルバー,レンズ,5,マウント,改造,helios 85mm f1,5,helios,85mm,f1,5,85mm f1,5,HELIOS 40,85mm F1,5,マウント,Helios 40,レンズ,HELIOS 40,マウントM42,,1"
    words = "● tessar 40/4.5 T M42 レンズ,M42,m42,m42,TM,M42,TM,M42,M42,レンズ,40/4.5 T Tessar,M42,TESSAR,m42,tessar,...,○,T,○,○,TM,レンズ,M42,m42,m42,...,レンズ,T,T,○,レンズ,テッサー,40/4.5,レンズ,テッサー,テッサー,Tessar T,テッサー,レンズ,テッサー,M42,Tessar,● テッサー 40/4.5 T M42 レンズ,レンズ,テッサー,レンズ,テッサー,Tessar,T,レンズ,Ｍ４２,M42,レンズ,レンズ,テッサー,M42,Tessar,T,M42,レンズ,テッサー,M42,T,M42,レンズ,TESSAR,M42,レンズ,TESSAR,M42,レンズ,TESSAR,M42,レンズ,m42 tessar,m42,tessar,m42 tessar,レンズ,テッサー,M４２,Tessar T,M42,テッサー,tessar m42,tessar,tessar,m42,TESSAR,M42,レンズ,Tessar,T M42,レンズ,● テッサー 40/4.5 T M42 レンズ,,1"
pp LensInfoAnalysis::create_ranking(words)
  end

  # Googleの検索結果
  task exec12: :environment do
    def search_google_related_words_for_lens(search_word)
      session = TaskCommon::get_session

      session.visit "https://www.google.co.jp/search?q=#{URI.escape(search_word + " レンズ")}"

      session.all("._Bmc").map{|r| r.text}
    end

    # pp fetch_google_related_words "COLOR-YASHINON-DX 45mm f1.7 SONY α Eマウント改造"
    # pp fetch_google_related_words "COLOR-YASHINON-DX"
    # pp fetch_google_related_words "Meyer-optik DOMIPLAN 50mm/f2.8 ZEBRA"
    # pp fetch_google_related_words "Meyer-optik DOMIPLAN"
    pp search_google_related_words_for_lens "ZEISS 【中古】(ツアイス) ZEISS マクロプラナー50/2 ZF2(ニコンAis)"

  end

  # コンテナから削除する。
  task exec11: :environment do
    conoha_obs_conf = Rails.application.config.api.conoha_object_strage
    os = OpenStack::Connection.create(
      :username => conoha_obs_conf[:user_id],
      :api_key => conoha_obs_conf[:password],
      :authtenant_id => conoha_obs_conf[:tenant_id],
      :auth_url => conoha_obs_conf[:auth_url],
      :service_type => "object-store",
      :is_debug => true
    )
    container_name = 'lens-manage-private'
    cont = os.container(container_name)

    work_dir = '/home/app/share/test/'
    cont.objects_detail.each do |path, info|
      if path =~ /development\/\//
        pp path
        cont.delete_object(path)
      end
    end
  end

  # コンテナ間を移動する。
  task exec10: :environment do
    conoha_obs_conf = Rails.application.config.api.conoha_object_strage
    os = OpenStack::Connection.create(
      :username => conoha_obs_conf[:user_id],
      :api_key => conoha_obs_conf[:password],
      :authtenant_id => conoha_obs_conf[:tenant_id],
      :auth_url => conoha_obs_conf[:auth_url],
      :service_type => "object-store",
      :is_debug => true
    )
    container_name = 'lens-manage'
    container_name2 = 'lens-manage-private'
    cont = os.container(container_name)

    cont.objects_detail.each do |path, info|
      unless path =~ /production\/.+c_/
        pp path
        cont.object(path).move(
          path,
          container_name2,
          {
            :content_type=>info[:content_type]
          }
        )
      end
    end
  end

  task exec9: :environment do
    # https://github.com/ruby-openstack/ruby-openstack/wiki/Object-Storage
    conoha_obs_conf = Rails.application.config.api.conoha_object_strage
    os = OpenStack::Connection.create(
      :username => conoha_obs_conf[:user_id],
      :api_key => conoha_obs_conf[:password],
      :authtenant_id => conoha_obs_conf[:tenant_id],
      :auth_url => conoha_obs_conf[:auth_url],
      :service_type => "object-store",
      :is_debug => true
    )

    container_name = 'lens-manage'
    # pp "get_info: #{os.get_info}"
    # pp "containers: #{os.containers}"
    # pp "containers_detail: #{os.containers_detail}"
    # pp "container_exists?: #{os.container_exists?(container_name)}"
    pp "create_container: #{os.create_container(container_name, '.r:*')}" unless os.container_exists?(container_name)

    cont = os.container(container_name)
    pp "cont: #{cont}"
    pp cont.container_metadata 
    # pp cont.set_metadata({'X-Container-Read'=>'.r:*,.rlistings'})
    pp cont.metadata
    # pp cont.set_metadata({'X-Container-Read'=>'.r:*', "X-Container-Meta-Author"=> "msa", "version"=>"1.2", :date=>"today"})
    pp cont.objects_detail
    # pp cont.empty?

    object_name = 'test.txt'
    pp cont.object_exists?(object_name)
    new_obj = cont.create_object(object_name, {:metadata=>{"herpy"=>"derp"}, :content_type=>"text/plain"}, "this is the data")
    pp new_obj.write("over writting the data")
    pp new_obj.data
    # pp cont.delete_object(object_name)

    object_name = 'text/test2.txt'
    pp cont.object_exists?(object_name)
    new_obj = cont.create_object(object_name, {:metadata=>{"herpy"=>"derp"}, :content_type=>"text/plain"}, "this is the data")
    pp new_obj.data

#     object_image_name = 'test.jpg'
#     image_path = '/tmp/lens-manage/images/LEM/LEM_311.jpg'
#     new_obj = cont.create_object(object_image_name, {:metadata=>{"herpy"=>"derp", 'X-Container-Read'=>'.r:*'}, :content_type=>MimeMagic.by_magic(File.open(image_path)).type
# }, open(image_path))
#     pp new_obj
    # pp cont.delete_object(object_image_name)
    
    # pp "delete_container: #{os.delete_container(container_name)}"
  end

  task exec8: :environment do
    conoha_obs_conf = Rails.application.config.api.conoha_object_strage
    client = ConoStorage.new(
      tenant_id: conoha_obs_conf[:tenant_id],
      username: conoha_obs_conf[:user_id],
      password: conoha_obs_conf[:password],
      endpoint: conoha_obs_conf[:end_point],
      web_mode: true # Web公開モード
    )

    # コンテナ作成
pp 'test1'
    # client.put_container('lens-manage')
    # オブジェクトアップロード
pp 'test2'
    # client.put_object('lens-manage/images/LEM','/tmp/lens-manage/images/LEM/LEM_311.jpg').url
    # 削除予約付きオブジェクトアップロード
    # client.put_object('awesome_gifs', 'wan.gif', hearders: { 'X-Delete-At' => "1170774000" } ) # Custom Headers
    # オブジェクトのメタデータなどダウンロード
pp 'test3'
    # client.get_object('lens-manage/images/LEM', 'LEM_311.jpg')
    # オブジェクト削除
    # client.delete_object('awesome_gifs', 'nyan.gif')
    # コンテナ削除
    # client.delete_container('awesome_gifs').status
  end

  task exec7: :environment do
    input_path = '/tmp/lens-manage/images/LEM/LEM_311.jpg'
    out_path = '/tmp/lens-manage/images/LEM/c'
    pp ConvertUtils::convert_image(input_path, out_path, 'テスト', 'c_')
  end

  task exec6: :environment do
    conoha_obs_conf = Rails.application.config.api.conoha_object_strage
    auth = ConohaObjectStrage::Auth.new
    auth.user_id = conoha_obs_conf[:user_id]
    auth.password = conoha_obs_conf[:password]
    auth.tenant_id = conoha_obs_conf[:tenant_id]
    auth.auth_url = conoha_obs_conf[:auth_url]
    auth.end_point = conoha_obs_conf[:end_point]

    conoha_obs = ConohaObjectStrage.new(auth, '/tmp/lens-manage')
    # conoha_obs.set_dir(Rails.env)
    # conoha_obs.create_container('images/LEM')
    # # pp conoha_obs.upload('images/LEM/LEM_311.jpg')
    # # conoha_obs.create_container('images/LEM/c')
    # # pp conoha_obs.upload('images/LEM/c/c_LEM_311.jpg')
    # pp conoha_obs.download('images/LEM/c/c_LEM_311.jpg')
  end

  task exec5: :environment do
    avarable_stock_pattern = Regexp.new("在庫状況：○")
    pp test = "在庫状況：×：通常2-3日でお届け".match(avarable_stock_pattern).present?
    pp test = "在庫状況：○：通常2-3日でお届け".match(avarable_stock_pattern).present?
    pp test = avarable_stock_pattern.match("在庫状況：○：通常2-3日でお届け").present?

  end

  task exec4: :environment do
    targets = ["http://fotomutori.com/blog/?p=623",]

    price_pattern = Regexp.new("/blog/\\?p=\\d+")
    targets.each do |target|
      if md = target.gsub(/,/, '').match(price_pattern) # 価格
        pp md
      else
        pp "What's a fuck!?"
      end
    end
  end

  task exec3: :environment do
    targets = ["メーカー：ズノー光学工業 モデル名：ZUNOW Cine 13mm F1.9 （Dマウント） ランク ：ＡＢ 商品価格：￥8,800- 初期不良：７日以内 業務ＣＤ：FH221-02 付属品 ：写真に写っている物が全てです コメント：Dマウントのシネレンズ 外観は少し歴史を感じさせるような状 ...",
    "メーカー：ダルメイヤー モデル名：SPEED ANASTIGMAT 25mm F1.5 （Cマウント） ランク ：ＡＢ－ 商品価格：￥84,800- 初期不良：７日以内 業務ＣＤ：FC430-06 付属品 ：写真に写っている物が全てです コメント：Cマウントのシネレンズ ダルメイヤーは1860年に創立されたイ ...",]

    price_pattern = Regexp.new("商品価格：￥(\\d+)-")
    targets.each do |target|
      if md = target.gsub(/,/, '').match(price_pattern) # 価格
        pp md
      else
        pp "What's a fuck!?"
      end
    end
  end

  task exec2: :environment do
    # session = TaskCommon::get_session

    # target_url = "http://lucky-camera.com/shop/KONICA/#gsc.tab=0"
    # session.visit target_url
    session = Capybara.string(HTML)

    common_href
    # 全てのアンカーを取得する 
    session.all(:css, '#content .article').each do |article|
      result = article.text.gsub(/\r|\n|\t/, '').strip
      Rails.logger.info result
      # pp article.all(:css, 'a').map do {|a| a[:href]}.uniq
      # pp article['innerHTML'].gsub(/\r|\n|\t/, '').strip
      # pp article[:text]
    end
  end

  task exec: :environment do
    TaskCommon::set_log 'test'

    session = TaskCommon::get_session

    # 対象URLに遷移する
    session.visit "https://item.mercari.com/jp/m55232908152/"

    groups = {}
    # 全てのアンカーを取得する 
    session.all(:css, 'a').each do |anchor|
      # pp anchor[:href]
      Rails.logger.info anchor[:href]
    end
  end
end

HTML = <<"EOS"
<body class="archive tag tag-KONICA tag-41">

<header>
<div class="wrap">

    <div class="utilities">
  <ul class="subnavi clearfix">
                <li><a href="http://lucky-camera.com/usces-cart/" class="cart">カート</a></li>

    <li class="logout"><a href="http://lucky-camera.com/usces-member/?page=login" class="usces_login_a">ログイン</a></li>
  </ul>

  </div>
  


  
 <div id="site-title" class="logo">
 <a href="http://lucky-camera.com/" title="lucky camera online shop | 新宿ラッキーカメラ店" rel="home"><img src="http://158.199.190.74/wp/wp-content/uploads/2013/12/logo2.gif" alt="lucky camera online shop | 新宿ラッキーカメラ店"></a>
 </div>

 <hgroup>
    <h2 class="blogname">カメラの買取・下取りは新宿のラッキーカメラ</h2>
    <h3 class="discprition">ラッキーカメラ <strong>TEL 03-3354-7898</strong></h3>
  <p class="arrow"><a href="http://lucky-camera.com/english/" target="_blank">English</a></p>
  </hgroup>


<nav class="animenu">
  <input type="checkbox" id="button">
  <label for="button" onclick="">Menu</label>
      <div class="menu-%e3%82%b0%e3%83%ad%e3%83%bc%e3%83%90%e3%83%ab%e3%83%a1%e3%83%8b%e3%83%a5%e3%83%bc-container"><ul id="menu-%e3%82%b0%e3%83%ad%e3%83%bc%e3%83%90%e3%83%ab%e3%83%a1%e3%83%8b%e3%83%a5%e3%83%bc" class="mainnavi clearfix"><li id="menu-item-1585" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-1585"><a href="/#search">カメラを探す</a></li>
<li id="menu-item-1527" class="menu-item menu-item-type-taxonomy menu-item-object-category menu-item-1527"><a href="http://lucky-camera.com/item">商品一覧</a></li>
<li id="menu-item-101" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-101"><a href="http://lucky-camera.com/wanted/">買取・下取り</a></li>
<li id="menu-item-32030" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-32030"><a href="http://lucky-camera.com/repair/">修理</a></li>
<li id="menu-item-102" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-102"><a href="http://lucky-camera.com/shop/">店舗情報</a></li>
<li id="menu-item-104" class="menu-item menu-item-type-taxonomy menu-item-object-category menu-item-104"><a href="http://lucky-camera.com/information/">お知らせ</a></li>
<li id="menu-item-100" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-100"><a href="http://lucky-camera.com/contact/">お問い合わせ</a></li>
</ul></div> </nav>

</div>
</header><!-- end of header -->

<div class="wrap">


<div id="main" class="clearfix">
<!-- end header -->
<div id="content" class="one-column">

<div id="archivehead">
  <h1>商品一覧</h1>
  <p>ライカ、ハッセルブラッドなどの舶来製カメラからニコン、キャノンなどの国内ブランドまで幅広く販売しております。<br>
特にライカ関連の品物は多数在庫をしております。新宿にお越しの際は是非お立ち寄りくださいませ。</p>
</div>

<div class="navi top">
  <div class="pankuzu">
        <span class="maker parent">メーカー &gt; </span>
        <span>KONICA</span>
      </div>
  <div class="pagination"><span class="current">1</span><a href="http://lucky-camera.com/shop/KONICA/page/2/" class="inactive">2</a></div>
</div>

<div class="items">
  <div class="article" style="height: 339px;"></div>
      <article class="article soldout" style="height: 339px;">

        <time datetime="">UPDATE:2017.05.29</time>
        <div class="thumb">
          <a href="http://lucky-camera.com/item/konica%ef%bc%88%e3%82%b3%e3%83%8b%e3%82%ab%ef%bc%89%e3%83%98%e3%82%ad%e3%82%b5%e3%83%bcrf%e3%80%80%e3%83%9c%e3%83%87%e3%82%a3/"><img width="245" height="184" src="http://lucky-camera.com/wp/wp-content/uploads/2017/05/17052806-300x225.jpg" class="attachment-245x190" alt="17052806"></a>
        </div>
        
        <div class="item_detail">
          <div class="cat">
                        <span class="item_used">中古</span>
                                    <span class="label_soldout">売切れ</span>
                        <a href="http://lucky-camera.com/shop/KONICA" rel="tag">KONICA</a>          </div>
          <h4><a href="http://lucky-camera.com/item/konica%ef%bc%88%e3%82%b3%e3%83%8b%e3%82%ab%ef%bc%89%e3%83%98%e3%82%ad%e3%82%b5%e3%83%bcrf%e3%80%80%e3%83%9c%e3%83%87%e3%82%a3/">Konica（コニカ）ヘキサーRF　ボディ</a></h4>
          <div class="cat">
          レンジファインダー         </div>
          <div class="price"><a href="http://lucky-camera.com/item/konica%ef%bc%88%e3%82%b3%e3%83%8b%e3%82%ab%ef%bc%89%e3%83%98%e3%82%ad%e3%82%b5%e3%83%bcrf%e3%80%80%e3%83%9c%e3%83%87%e3%82%a3/">¥72,000</a></div>
          <div class="stecker">
            <img src="http://lucky-camera.com/wp/wp-content/themes/welcart_novel_lucky/library/img/stecker_normal.png" alt="">
          </div>
        </div>
      </article>      <article class="article" style="height: 339px;">

        <time datetime="">UPDATE:2017.04.02</time>
        <div class="thumb">
          <a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab-m%e3%83%98%e3%82%ad%e3%82%b5%e3%83%8e%e3%83%b3%e3%80%8028mmf2-8/"><img width="245" height="184" src="http://lucky-camera.com/wp/wp-content/uploads/2017/04/C17040201-300x225.jpg" class="attachment-245x190" alt="C17040201"></a>
        </div>
        
        <div class="item_detail">
          <div class="cat">
                        <span class="item_used">中古</span>
                                                <a href="http://lucky-camera.com/shop/KONICA" rel="tag">KONICA</a>          </div>
          <h4><a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab-m%e3%83%98%e3%82%ad%e3%82%b5%e3%83%8e%e3%83%b3%e3%80%8028mmf2-8/">KONICA(コニカ) Mヘキサノン　28mmF2.8</a></h4>
          <div class="cat">
          レンジファインダー用          </div>
          <div class="price"><a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab-m%e3%83%98%e3%82%ad%e3%82%b5%e3%83%8e%e3%83%b3%e3%80%8028mmf2-8/">¥74,800</a></div>
          <div class="stecker">
            <img src="http://lucky-camera.com/wp/wp-content/themes/welcart_novel_lucky/library/img/stecker_normal.png" alt="">
          </div>
        </div>
      </article>      <article class="article" style="height: 340px;">

        <time datetime="">UPDATE:2017.02.05</time>
        <div class="thumb">
          <a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab%e3%80%80%e3%83%90%e3%83%aa%e3%83%95%e3%82%a9%e3%83%bc%e3%82%ab%e3%83%ab%e3%83%98%e3%82%ad%e3%82%b5%e3%83%8e%e3%83%b3ar35-100f2-8/"><img width="245" height="184" src="http://lucky-camera.com/wp/wp-content/uploads/2017/02/17020501-300x225.jpg" class="attachment-245x190" alt="17020501"></a>
        </div>
        
        <div class="item_detail">
          <div class="cat">
                        <span class="item_used">中古</span>
                                                <a href="http://lucky-camera.com/shop/KONICA" rel="tag">KONICA</a>          </div>
          <h4><a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab%e3%80%80%e3%83%90%e3%83%aa%e3%83%95%e3%82%a9%e3%83%bc%e3%82%ab%e3%83%ab%e3%83%98%e3%82%ad%e3%82%b5%e3%83%8e%e3%83%b3ar35-100f2-8/">KONICA(コニカ)　バリフォーカルヘキサノンAR35-100F2.8</a></h4>
          <div class="cat">
          MF一眼用         </div>
          <div class="price"><a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab%e3%80%80%e3%83%90%e3%83%aa%e3%83%95%e3%82%a9%e3%83%bc%e3%82%ab%e3%83%ab%e3%83%98%e3%82%ad%e3%82%b5%e3%83%8e%e3%83%b3ar35-100f2-8/">¥59,800</a></div>
          <div class="stecker">
            <img src="http://lucky-camera.com/wp/wp-content/themes/welcart_novel_lucky/library/img/stecker_normal.png" alt="">
          </div>
        </div>
      </article>      <article class="article soldout" style="height: 340px;">

        <time datetime="">UPDATE:2017.01.08</time>
        <div class="thumb">
          <a href="http://lucky-camera.com/item/%e3%82%b3%e3%83%8b%e3%82%ab%ef%bc%88konica%e3%80%80%e2%85%a2m%e3%80%80%e5%85%83%e7%ae%b1%e3%80%81%e3%83%8f%e3%83%bc%e3%83%95%e3%82%b5%e3%82%a4%e3%82%ba%e3%82%a2%e3%83%80%e3%83%97%e3%82%bf%e3%83%bc/"><img width="245" height="184" src="http://lucky-camera.com/wp/wp-content/uploads/2017/01/17010801-300x225.jpg" class="attachment-245x190" alt="17010801"></a>
        </div>
        
        <div class="item_detail">
          <div class="cat">
                        <span class="item_used">中古</span>
                                    <span class="label_soldout">売切れ</span>
                        <a href="http://lucky-camera.com/shop/KONICA" rel="tag">KONICA</a>          </div>
          <h4><a href="http://lucky-camera.com/item/%e3%82%b3%e3%83%8b%e3%82%ab%ef%bc%88konica%e3%80%80%e2%85%a2m%e3%80%80%e5%85%83%e7%ae%b1%e3%80%81%e3%83%8f%e3%83%bc%e3%83%95%e3%82%b5%e3%82%a4%e3%82%ba%e3%82%a2%e3%83%80%e3%83%97%e3%82%bf%e3%83%bc/">コニカ（Konica)　ⅢM　元箱、ハーフサイズアダプター付き</a></h4>
          <div class="cat">
          コンパクト・その他         </div>
          <div class="price"><a href="http://lucky-camera.com/item/%e3%82%b3%e3%83%8b%e3%82%ab%ef%bc%88konica%e3%80%80%e2%85%a2m%e3%80%80%e5%85%83%e7%ae%b1%e3%80%81%e3%83%8f%e3%83%bc%e3%83%95%e3%82%b5%e3%82%a4%e3%82%ba%e3%82%a2%e3%83%80%e3%83%97%e3%82%bf%e3%83%bc/">¥26,800</a></div>
          <div class="stecker">
            <img src="http://lucky-camera.com/wp/wp-content/themes/welcart_novel_lucky/library/img/stecker_normal.png" alt="">
          </div>
        </div>
      </article>      <article class="article soldout" style="height: 340px;">

        <time datetime="">UPDATE:2016.11.15</time>
        <div class="thumb">
          <a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab%e3%80%80%e3%83%93%e3%83%83%e3%82%af%e3%83%9f%e3%83%8b%e3%80%80bm-301s/"><img width="245" height="184" src="http://lucky-camera.com/wp/wp-content/uploads/2016/11/16111523-300x225.jpg" class="attachment-245x190" alt="16111523"></a>
        </div>
        
        <div class="item_detail">
          <div class="cat">
                        <span class="item_used">中古</span>
                                    <span class="label_soldout">売切れ</span>
                        <a href="http://lucky-camera.com/shop/KONICA" rel="tag">KONICA</a>          </div>
          <h4><a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab%e3%80%80%e3%83%93%e3%83%83%e3%82%af%e3%83%9f%e3%83%8b%e3%80%80bm-301s/">KONICA(コニカ)　ビックミニ　BM-301S</a></h4>
          <div class="cat">
          コンパクト・その他         </div>
          <div class="price"><a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab%e3%80%80%e3%83%93%e3%83%83%e3%82%af%e3%83%9f%e3%83%8b%e3%80%80bm-301s/">¥12,000</a></div>
          <div class="stecker">
            <img src="http://lucky-camera.com/wp/wp-content/themes/welcart_novel_lucky/library/img/stecker_normal.png" alt="">
          </div>
        </div>
      </article>      <article class="article soldout" style="height: 340px;">

        <time datetime="">UPDATE:2016.11.15</time>
        <div class="thumb">
          <a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab%e3%80%80%e3%83%93%e3%83%83%e3%82%af%e3%83%9f%e3%83%8b%e3%80%80bm-301/"><img width="245" height="184" src="http://lucky-camera.com/wp/wp-content/uploads/2016/11/16111522-300x225.jpg" class="attachment-245x190" alt="16111522"></a>
        </div>
        
        <div class="item_detail">
          <div class="cat">
                        <span class="item_used">中古</span>
                                    <span class="label_soldout">売切れ</span>
                        <a href="http://lucky-camera.com/shop/KONICA" rel="tag">KONICA</a>          </div>
          <h4><a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab%e3%80%80%e3%83%93%e3%83%83%e3%82%af%e3%83%9f%e3%83%8b%e3%80%80bm-301/">KONICA(コニカ)　ビックミニ　BM-301</a></h4>
          <div class="cat">
          コンパクト・その他         </div>
          <div class="price"><a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab%e3%80%80%e3%83%93%e3%83%83%e3%82%af%e3%83%9f%e3%83%8b%e3%80%80bm-301/">¥10,800</a></div>
          <div class="stecker">
            <img src="http://lucky-camera.com/wp/wp-content/themes/welcart_novel_lucky/library/img/stecker_normal.png" alt="">
          </div>
        </div>
      </article>      <article class="article" style="height: 340px;">

        <time datetime="">UPDATE:2016.10.05</time>
        <div class="thumb">
          <a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab%e3%80%80auto%ef%bc%8dup-ca-100%ef%bd%9e50cm/"><img width="245" height="184" src="http://lucky-camera.com/wp/wp-content/uploads/2016/10/16100302-300x225.jpg" class="attachment-245x190" alt="16100302"></a>
        </div>
        
        <div class="item_detail">
          <div class="cat">
                        <span class="item_used">中古</span>
                                                <a href="http://lucky-camera.com/shop/KONICA" rel="tag">KONICA</a>          </div>
          <h4><a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab%e3%80%80auto%ef%bc%8dup-ca-100%ef%bd%9e50cm/">KONICA(コニカ)　AUTO－UP CA 100～50cm</a></h4>
          <div class="cat">
          アクセサリー          </div>
          <div class="price"><a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab%e3%80%80auto%ef%bc%8dup-ca-100%ef%bd%9e50cm/">¥2,800</a></div>
          <div class="stecker">
            <img src="http://lucky-camera.com/wp/wp-content/themes/welcart_novel_lucky/library/img/stecker_normal.png" alt="">
          </div>
        </div>
      </article>      <article class="article" style="height: 340px;">

        <time datetime="">UPDATE:2016.05.19</time>
        <div class="thumb">
          <a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab-m%e3%83%98%e3%82%ad%e3%82%b5%e3%83%8e%e3%83%b350mmf2/"><img width="245" height="184" src="http://lucky-camera.com/wp/wp-content/uploads/2016/05/a16051701-300x225.jpg" class="attachment-245x190" alt="a16051701"></a>
        </div>
        
        <div class="item_detail">
          <div class="cat">
                        <span class="item_used">中古</span>
                                                <a href="http://lucky-camera.com/shop/KONICA" rel="tag">KONICA</a>          </div>
          <h4><a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab-m%e3%83%98%e3%82%ad%e3%82%b5%e3%83%8e%e3%83%b350mmf2/">KONICA(コニカ) Mヘキサノン50mmF2</a></h4>
          <div class="cat">
          MF一眼用         </div>
          <div class="price"><a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab-m%e3%83%98%e3%82%ad%e3%82%b5%e3%83%8e%e3%83%b350mmf2/">¥68,000</a></div>
          <div class="stecker">
            <img src="http://lucky-camera.com/wp/wp-content/themes/welcart_novel_lucky/library/img/stecker_normal.png" alt="">
          </div>
        </div>
      </article>      <article class="article" style="height: 340px;">

        <time datetime="">UPDATE:2016.05.08</time>
        <div class="thumb">
          <a href="http://lucky-camera.com/item/konica%ef%bc%88%e3%82%b3%e3%83%8b%e3%82%ab%ef%bc%89-m%e3%83%98%e3%82%ad%e3%82%b5%e3%83%8e%e3%83%b3-28mmf2-8/"><img width="245" height="184" src="http://lucky-camera.com/wp/wp-content/uploads/2016/05/16050801-300x225.jpg" class="attachment-245x190" alt="16050801"></a>
        </div>
        
        <div class="item_detail">
          <div class="cat">
                        <span class="item_used">中古</span>
                                                <a href="http://lucky-camera.com/shop/KONICA" rel="tag">KONICA</a>          </div>
          <h4><a href="http://lucky-camera.com/item/konica%ef%bc%88%e3%82%b3%e3%83%8b%e3%82%ab%ef%bc%89-m%e3%83%98%e3%82%ad%e3%82%b5%e3%83%8e%e3%83%b3-28mmf2-8/">KONICA（コニカ） Mヘキサノン 28mmF2.8</a></h4>
          <div class="cat">
          レンジファインダー用          </div>
          <div class="price"><a href="http://lucky-camera.com/item/konica%ef%bc%88%e3%82%b3%e3%83%8b%e3%82%ab%ef%bc%89-m%e3%83%98%e3%82%ad%e3%82%b5%e3%83%8e%e3%83%b3-28mmf2-8/">¥72,000</a></div>
          <div class="stecker">
            <img src="http://lucky-camera.com/wp/wp-content/themes/welcart_novel_lucky/library/img/stecker_normal.png" alt="">
          </div>
        </div>
      </article>      <article class="article" style="height: 340px;">

        <time datetime="">UPDATE:2015.12.20</time>
        <div class="thumb">
          <a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab-l%e3%83%98%e3%82%ad%e3%82%b5%e3%83%8e%e3%83%b3-50mmf1-9/"><img width="245" height="184" src="http://lucky-camera.com/wp/wp-content/uploads/2015/12/15122001-300x225.jpg" class="attachment-245x190" alt="15122001"></a>
        </div>
        
        <div class="item_detail">
          <div class="cat">
                        <span class="item_used">中古</span>
                                                <a href="http://lucky-camera.com/shop/KONICA" rel="tag">KONICA</a>          </div>
          <h4><a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab-l%e3%83%98%e3%82%ad%e3%82%b5%e3%83%8e%e3%83%b3-50mmf1-9/">KONICA(コニカ) Lヘキサノン  50mmF1.9</a></h4>
          <div class="cat">
          レンジファインダー用          </div>
          <div class="price"><a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab-l%e3%83%98%e3%82%ad%e3%82%b5%e3%83%8e%e3%83%b3-50mmf1-9/">¥59,800</a></div>
          <div class="stecker">
            <img src="http://lucky-camera.com/wp/wp-content/themes/welcart_novel_lucky/library/img/stecker_normal.png" alt="">
          </div>
        </div>
      </article>      <article class="article" style="height: 340px;">

        <time datetime="">UPDATE:2014.10.15</time>
        <div class="thumb">
          <a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab-%e3%83%97%e3%83%ac%e3%82%b9%e3%83%98%e3%82%ad%e3%82%b5%e3%83%8e%e3%83%b360mmf5-6/"><img width="245" height="184" src="http://lucky-camera.com/wp/wp-content/uploads/2014/10/a14101306-300x225.jpg" class="attachment-245x190" alt="a14101306"></a>
        </div>
        
        <div class="item_detail">
          <div class="cat">
                        <span class="item_used">中古</span>
                                                <a href="http://lucky-camera.com/shop/KONICA" rel="tag">KONICA</a>          </div>
          <h4><a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab-%e3%83%97%e3%83%ac%e3%82%b9%e3%83%98%e3%82%ad%e3%82%b5%e3%83%8e%e3%83%b360mmf5-6/">KONICA(コニカ) プレス<br>ヘキサノン60mmF5.6</a></h4>
          <div class="cat">
          中判カメラ         </div>
          <div class="price"><a href="http://lucky-camera.com/item/konica%e3%82%b3%e3%83%8b%e3%82%ab-%e3%83%97%e3%83%ac%e3%82%b9%e3%83%98%e3%82%ad%e3%82%b5%e3%83%8e%e3%83%b360mmf5-6/">¥63,000</a></div>
          <div class="stecker">
            <img src="http://lucky-camera.com/wp/wp-content/themes/welcart_novel_lucky/library/img/stecker_normal.png" alt="">
          </div>
        </div>
      </article></div>
<div class="clearfix"></div>

<div class="navi">
  <div class="pagination"><span class="current">1</span><a href="http://lucky-camera.com/shop/KONICA/page/2/" class="inactive">2</a></div>
</div>

<div class="clearfix"></div>

<a id="search"></a>
<script type="text/javascript">
$(function(){
  $('.category_list').find('li:not(".all")').each(function(){
  
    $(this).find('.btn').click(function(){
      if(!$(this).parent().hasClass('active')){
        toggleCategory(this);
      }else{
        $(this).next().slideUp(300);
        $(this).parents('.category_list').animate({marginBottom: 0},{duration: 300});
        $(this).parent().removeClass('active');
      }
    });
    
  })
});

//PC用
function toggleCategory(elm){
  var $current_li = $('.category_list .active');
  //
  if($current_li.size()){
    //親が同じかどうか
    if($current_li.parent('.category_list').attr('id') != $(elm).parents('.category_list').attr('id')){
      $current_li.parent('.category_list').animate({marginBottom: 0},{duration: 300});
    }
    //
    $current_li.find('.subcat_wrap').slideUp(300, function(){
      showCategory(elm);
    });
    
    $current_li.removeClass('active');
  }else{
    showCategory(elm);
  }
}

function showCategory(elm){
  $('.subcat_wrap').removeClass('active');
  //
  var $parent = $(elm).parents('.category_list');
  var $sub = $(elm).next(); 
  //表示
  if($sub.css('position') == 'absolute'){
    $parent.animate({marginBottom: $sub.height()+20},{duration: 500});
  }
  $sub.slideDown();
  $(elm).parent().addClass('active');
}
</script>
<nav class="searchbox">

  <h3><span>カメラを探す</span></h3>
  
<script>
  (function() {
    var cx = '000728370899527545702:wsm_sxaqcvo';
    var gcse = document.createElement('script');
    gcse.type = 'text/javascript';
    gcse.async = true;
    gcse.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') +
        '//www.google.com/cse/cse.js?cx=' + cx;
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(gcse, s);
  })();
</script>
<div id="___gcse_0"><div class="gsc-control-cse gsc-control-cse-ja"><div class="gsc-control-wrapper-cse" dir="ltr"><form class="gsc-search-box gsc-search-box-tools" accept-charset="utf-8"><table cellspacing="0" cellpadding="0" class="gsc-search-box"><tbody><tr><td class="gsc-input"><div class="gsc-input-box" id="gsc-iw-id1"><table cellspacing="0" cellpadding="0" id="gs_id50" class="gstl_50 " style="width: 100%; padding: 0px;"><tbody><tr><td id="gs_tti50" class="gsib_a"><input autocomplete="off" type="text" size="10" class="gsc-input" name="search" title="検索" id="gsc-i-id1" x-webkit-speech="" x-webkit-grammar="builtin:search" lang="ja" dir="ltr" spellcheck="false" placeholder="カスタム検索" style="width: 100%; padding: 0px; border: none; margin: 0px; height: auto; outline: none; background: url(&quot;http://www.google.com/cse/static/images/1x/googlelogo_lightgrey_46x16dp.png&quot;) left center no-repeat rgb(255, 255, 255); text-indent: 48px;"></td><td class="gsib_b"><div class="gsst_b" id="gs_st50" dir="ltr"><a class="gsst_a" href="javascript:void(0)" style="display: none;"><span class="gscb_a" id="gs_cb50">×</span></a></div></td></tr></tbody></table></div><input type="hidden" name="bgresponse" id="bgresponse"></td><td class="gsc-search-button"><input type="image" src="https://www.google.com/uds/css/v2/search_box_icon.png" class="gsc-search-button gsc-search-button-v2" title="検索"></td><td class="gsc-clear-button"><div class="gsc-clear-button" title="結果をクリア">&nbsp;</div></td></tr></tbody></table><table cellspacing="0" cellpadding="0" class="gsc-branding"><tbody><tr><td class="gsc-branding-user-defined"></td><td class="gsc-branding-text"><div class="gsc-branding-text">powered by</div></td><td class="gsc-branding-img"><img src="https://www.google.com/cse/static/images/1x/googlelogo_grey_46x15dp.png" class="gsc-branding-img" srcset="https://www.google.com/cse/static/images/2x/googlelogo_grey_46x15dp.png 2x"></td></tr></tbody></table></form><div class="gsc-results-wrapper-nooverlay"><div class="gsc-tabsAreaInvisible"><div class="gsc-tabHeader gsc-inline-block gsc-tabhActive">カスタム検索</div><span class="gs-spacer"> </span></div><div class="gsc-tabsAreaInvisible"></div><div class="gsc-above-wrapper-area-invisible"><table cellspacing="0" cellpadding="0" class="gsc-above-wrapper-area-container"><tbody><tr><td class="gsc-result-info-container"><div class="gsc-result-info-invisible"></div></td><td class="gsc-orderby-container"><div class="gsc-orderby-invisible"><div class="gsc-orderby-label gsc-inline-block">表示順:</div><div class="gsc-option-menu-container gsc-inline-block"><div class="gsc-selected-option-container gsc-inline-block"><div class="gsc-selected-option">関連順</div><div class="gsc-option-selector"></div></div><div class="gsc-option-menu-invisible"><div class="gsc-option-menu-item gsc-option-menu-item-highlighted"><div class="gsc-option">関連順</div></div><div class="gsc-option-menu-item"><div class="gsc-option">更新日順</div></div></div></div></div></td></tr></tbody></table></div><div class="gsc-adBlockInvisible"></div><div class="gsc-wrapper"><div class="gsc-adBlockInvisible"></div><div class="gsc-resultsbox-invisible"><div class="gsc-resultsRoot gsc-tabData gsc-tabdActive"><table cellspacing="0" cellpadding="0" class="gsc-resultsHeader"><tbody><tr><td class="gsc-twiddleRegionCell"><div class="gsc-twiddle"><div class="gsc-title">ウェブ</div></div><div class="gsc-stats"></div><div class="gsc-results-selector gsc-all-results-active"><div class="gsc-result-selector gsc-one-result" title="検索結果を 1 件表示">&nbsp;</div><div class="gsc-result-selector gsc-more-results" title="検索結果をさらに表示">&nbsp;</div><div class="gsc-result-selector gsc-all-results" title="検索結果をすべて表示">&nbsp;</div></div></td><td class="gsc-configLabelCell"></td></tr></tbody></table><div><div class="gsc-expansionArea"></div></div></div></div></div></div></div></div></div>
  <div class="lists">
    <ul id="first_block" class="category_list">
    
      <li id="search_maker" class="maker"><div class="btn"><a href="javascript:void(0);">メーカー</a></div>
        <div class="maker subcat_wrap">
          <ul>
                        <li><a href="http://lucky-camera.com/shop/acall">Acall (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/agfa">Agfa (4)</a></li>
                        <li><a href="http://lucky-camera.com/shop/artisanartist">ARTISAN&amp;ARTIST (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/avenon">AVENON (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/billingham">BILLINGHAM (2)</a></li>
                        <li><a href="http://lucky-camera.com/shop/c-p-goerz-am-opt-co">C.P. GOERZ AM.OPT.CO. (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/Canon">Canon (157)</a></li>
                        <li><a href="http://lucky-camera.com/shop/carl-zeiss">Carl Zeiss (3)</a></li>
                        <li><a href="http://lucky-camera.com/shop/compass">compass (2)</a></li>
                        <li><a href="http://lucky-camera.com/shop/CONTAX">CONTAX (68)</a></li>
                        <li><a href="http://lucky-camera.com/shop/cosina">COSINA (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/elmo">ELMO (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/ensign">Ensign (2)</a></li>
                        <li><a href="http://lucky-camera.com/shop/etsumi">ETSUMI (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/fidelity">FIDELITY (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/fuji-film">FUJIFILM (11)</a></li>
                        <li><a href="http://lucky-camera.com/shop/fujifilm">FUJIFILM (3)</a></li>
                        <li><a href="http://lucky-camera.com/shop/futura">Futura (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/ge">GE (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/gitzo">GITZO (2)</a></li>
                        <li><a href="http://lucky-camera.com/shop/haka">Haka (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/hasselblad">HASSELBLAD (101)</a></li>
                        <li><a href="http://lucky-camera.com/shop/ihagee">Ihagee (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/k-f">K-F (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/kenko">Kenko (9)</a></li>
                        <li><a href="http://lucky-camera.com/shop/kipon">KIPON (2)</a></li>
                        <li><a href="http://lucky-camera.com/shop/kodak">KODAK (7)</a></li>
                        <li><a href="http://lucky-camera.com/shop/komura">KOMURA (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/KONICA">KONICA (14)</a></li>
                        <li><a href="http://lucky-camera.com/shop/kyocera">KYOCERA (3)</a></li>
                        <li><a href="http://lucky-camera.com/shop/LEICA">LEICA (389)</a></li>
                        <li><a href="http://lucky-camera.com/shop/leotax">Leotax (3)</a></li>
                        <li><a href="http://lucky-camera.com/shop/leotax-camera">Leotax Camera (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/linhof">Linhof (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/lucky">LUCKY (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/lucky-camera">Lucky camera (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/mamiya">MAMIYA (16)</a></li>
                        <li><a href="http://lucky-camera.com/shop/manfrotto">Manfrotto (2)</a></li>
                        <li><a href="http://lucky-camera.com/shop/marumi">MARUMI (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/matchtechnical">matchTechnical (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/meopta">MEOPTA (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/metz">Metz (3)</a></li>
                        <li><a href="http://lucky-camera.com/shop/microcord">MICROCORD (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/MINOLTA">MINOLTA (44)</a></li>
                        <li><a href="http://lucky-camera.com/shop/minox">MINOX (5)</a></li>
                        <li><a href="http://lucky-camera.com/shop/nicca">Nicca (2)</a></li>
                        <li><a href="http://lucky-camera.com/shop/Nikon">Nikon (280)</a></li>
                        <li><a href="http://lucky-camera.com/shop/novoflex">NOVOFLEX (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/OLYMPUS">OLYMPUS (50)</a></li>
                        <li><a href="http://lucky-camera.com/shop/other">other (2)</a></li>
                        <li><a href="http://lucky-camera.com/shop/panasonic">Panasonic (5)</a></li>
                        <li><a href="http://lucky-camera.com/shop/pax">Pax (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/PENTAX">PENTAX (71)</a></li>
                        <li><a href="http://lucky-camera.com/shop/petri">Petri (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/plaubel">PLAUBEL (2)</a></li>
                        <li><a href="http://lucky-camera.com/shop/RICOH">RICOH (8)</a></li>
                        <li><a href="http://lucky-camera.com/shop/robot">ROBOT (3)</a></li>
                        <li><a href="http://lucky-camera.com/shop/rodenstock">Rodenstock (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/rollei">Rollei (54)</a></li>
                        <li><a href="http://lucky-camera.com/shop/royflex">ROYFLEX (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/samyang">SAMYANG (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/schneider">Schneider (5)</a></li>
                        <li><a href="http://lucky-camera.com/shop/schneider-kreuznach">Schneider Kreuznach (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/sekonic">SEKONIC (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/semflex">SEMFLEX (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/sigma">SIGMA (22)</a></li>
                        <li><a href="http://lucky-camera.com/shop/slvshi">SLVSHI (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/SONY">SONY (18)</a></li>
                        <li><a href="http://lucky-camera.com/shop/steinheil">Steinheil (2)</a></li>
                        <li><a href="http://lucky-camera.com/shop/tamron">TAMRON (17)</a></li>
                        <li><a href="http://lucky-camera.com/shop/techartta">TECHARTTA (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/tessina">Tessina (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/tokina">Tokina (2)</a></li>
                        <li><a href="http://lucky-camera.com/shop/tokyo-kougaku">TOKYO KOUGAKU (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/%ef%bd%94%ef%bd%8f%ef%bd%90%ef%bd%83%ef%bd%8f%ef%bd%8e">ＴＯＰＣＯＮ (2)</a></li>
                        <li><a href="http://lucky-camera.com/shop/topcon">TOPCON (2)</a></li>
                        <li><a href="http://lucky-camera.com/shop/tower">TOWER (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/vixen">Vixen (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/voigtlander">Voigtlander (19)</a></li>
                        <li><a href="http://lucky-camera.com/shop/voigtlandercosina">Voigtlander/COSINA (10)</a></li>
                        <li><a href="http://lucky-camera.com/shop/vravon">VRAVON (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/walz">WALZ (3)</a></li>
                        <li><a href="http://lucky-camera.com/shop/wista">WISTA (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/wollensak">WOLLENSAK (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/yashica">YASHICA (11)</a></li>
                        <li><a href="http://lucky-camera.com/shop/ZEISS">ZEISS (13)</a></li>
                        <li><a href="http://lucky-camera.com/shop/zeiss-ikon">ZEISS IKON (4)</a></li>
                        <li><a href="http://lucky-camera.com/shop/zeisscosina">ZEISS/COSINA (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/zenza-bronica">Zenza Bronica (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/zenzabronica">ZenzaBronica (7)</a></li>
                        <li><a href="http://lucky-camera.com/shop/zero-halliburton">ZERO HALLIBURTON (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/zuiho">Zuiho (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/zunow">ZUNOW (2)</a></li>
                        <li><a href="http://lucky-camera.com/shop/%e3%83%8a%e3%83%bc%e3%82%b2%e3%83%ab">ナーゲル (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/%e3%83%ad%e3%82%b7%e3%82%a2%e8%a3%bd">ロシア製 (11)</a></li>
                        <li><a href="http://lucky-camera.com/shop/%e4%b8%8d%e6%98%8e">不明 (33)</a></li>
                        <li><a href="http://lucky-camera.com/shop/%e5%ae%ae%e5%b4%8e%e5%85%89%e5%ad%a6">宮崎光学 (2)</a></li>
                        <li><a href="http://lucky-camera.com/shop/%e5%b8%9d%e5%9b%bd%e5%85%89%e5%ad%a6">帝国光学 (3)</a></li>
                        <li><a href="http://lucky-camera.com/shop/%e7%94%b0%e4%b8%ad%e5%85%89%e5%ad%a6">田中光学 (2)</a></li>
                        <li><a href="http://lucky-camera.com/shop/%e8%bf%91%e4%bb%a3%e3%82%a4%e3%83%b3%e3%82%bf%e3%83%bc%e3%83%8a%e3%82%b7%e3%83%a7%e3%83%8a%e3%83%ab">近代インターナショナル (1)</a></li>
                        <li><a href="http://lucky-camera.com/shop/%e9%88%b4%e6%9c%a8%e5%85%89%e5%ad%a6">鈴木光学 (2)</a></li>
                      </ul>
        </div>
      </li>
      
      
      <li id="search_digital" class="digital"><div class="btn"><a href="javascript:void(0);">デジタルカメラ</a></div>
        <div class="digital subcat_wrap">
          <ul>
                        <li><a href="http://lucky-camera.com/shop/%e3%82%b3%e3%83%b3%e3%83%91%e3%82%af%e3%83%88">コンパクト (26)</a></li>
                        <li><a href="http://lucky-camera.com/shop/%e3%82%b3%e3%83%b3%e3%83%91%e3%82%af%e3%83%88%e3%83%bb%e3%81%9d%e3%81%ae%e4%bb%96-digital">コンパクト・その他 (2)</a></li>
                        <li><a href="http://lucky-camera.com/shop/%e3%83%ac%e3%83%b3%e3%82%ba%e4%ba%a4%e6%8f%9b%e5%bc%8f">レンズ交換式 (50)</a></li>
                      </ul>
        </div>
        
      </li>
      <li id="search_film" class="film"><div class="btn"><a href="javascript:void(0);">フィルムカメラ</a></div>
        <div class="film subcat_wrap">
          <ul>
                        <li><a href="http://lucky-camera.com/shop/35mm%e4%b8%80%e7%9c%bc%e3%82%ab%e3%83%a1%e3%83%a9">35mm一眼カメラ (95)</a></li>
                        <li><a href="http://lucky-camera.com/shop/%e3%82%b3%e3%83%b3%e3%83%91%e3%82%af%e3%83%88%e3%83%bb%e3%81%9d%e3%81%ae%e4%bb%96">コンパクト・その他 (89)</a></li>
                        <li><a href="http://lucky-camera.com/shop/%e3%83%ac%e3%83%b3%e3%82%b8%e3%83%95%e3%82%a1%e3%82%a4%e3%83%b3%e3%83%80%e3%83%bc">レンジファインダー (120)</a></li>
                        <li><a href="http://lucky-camera.com/shop/%e4%b8%ad%e5%88%a4%e3%82%ab%e3%83%a1%e3%83%a9">中判カメラ (71)</a></li>
                        <li><a href="http://lucky-camera.com/shop/%e5%a4%a7%e5%88%a4%e3%82%ab%e3%83%a1%e3%83%a9">大判カメラ (1)</a></li>
                      </ul>
        </div>
      </li>
    </ul>
    
    <ul id="second_block" class="category_list">
      <li id="search_lens" class="lens"><div class="btn"><a href="javascript:void(0);">レンズ</a></div>
        <div class="lens subcat_wrap">
          <ul>
                        <li><a href="http://lucky-camera.com/shop/af%e4%b8%80%e7%9c%bc%e7%94%a8">AF一眼用 (205)</a></li>
                        <li><a href="http://lucky-camera.com/shop/mf%e4%b8%80%e7%9c%bc%e7%94%a8">MF一眼用 (228)</a></li>
                        <li><a href="http://lucky-camera.com/shop/%e3%81%9d%e3%81%ae%e4%bb%96%e3%81%ae%e3%83%ac%e3%83%b3%e3%82%ba">その他のレンズ (38)</a></li>
                        <li><a href="http://lucky-camera.com/shop/%e3%83%ac%e3%83%b3%e3%82%b8%e3%83%95%e3%82%a1%e3%82%a4%e3%83%b3%e3%83%80%e3%83%bc%e7%94%a8">レンジファインダー用 (222)</a></li>
                        <li><a href="http://lucky-camera.com/shop/%e5%a4%a7%e5%88%a4%e7%94%a8%e3%83%ac%e3%83%b3%e3%82%ba">大判用レンズ (6)</a></li>
                      </ul>
        </div>
      </li>
      
      <li id="search_accessary" class="accessary"><div class="btn"><a href="javascript:void(0);">アクセサリー/その他</a></div>
        <div class="accessary subcat_wrap">
          <ul>
                        <li><a href="http://lucky-camera.com/shop/%e3%82%a2%e3%82%af%e3%82%bb%e3%82%b5%e3%83%aa%e3%83%bc">アクセサリー (391)</a></li>
                        <li><a href="http://lucky-camera.com/shop/fainder">ファインダー (65)</a></li>
                        <li><a href="http://lucky-camera.com/shop/sankyaku">三脚・一脚・雲台 (7)</a></li>
                      </ul>
        </div>
      </li>
      
      
      <li id="search_all" class="all"><div class="btn"><a href="/item/">商品一覧</a></div></li>
      
    </ul>
    
  <div class="clearfix"></div>
    
  </div>
</nav></div><!-- end of content -->

</div><!-- end of main -->


</div><!-- end of wrap -->

<footer>
  <div class="wrap">
  
    <div class="block">
      <h4>ラッキーカメラ店 店舗情報</h4>
      <dl>
        <dt>住所</dt>
        <dd>東京都新宿区新宿3-3-9<br>
  伍名館ビル1F</dd>
        <dt>TEL</dt>
        <dd>03-3354-7898</dd>
        <dt>営業時間</dt>
        <dd>10:00〜20:00（年中無休）</dd>
      </dl>
      <div class="contact bigbtn">
        <a href="/contact/">お問い合わせはこちら</a>
      </div>
    </div>
    
    <div class="block">
      <h4>アクセスマップ</h4>
      <div>
        <a href="/shop/#access"><img src="http://lucky-camera.com/wp/wp-content/themes/welcart_novel_lucky/library/img/footer_map.jpg" alt=""></a>
      </div>
      <p class="arrow"><a href="/shop/#access">店舗情報</a></p>
    </div>
    
    <div class="block">
      <h4>カメラ買取専用ダイヤル</h4>
      <h5><strong>0120-00-9553</strong></h5>
      <p>国産・舶来のカメラ、レンズ、パーツなど、使わなくなった物がありましたら高価買い取りいたします！</p>
      <p class="arrow"><a href="/wanted/">買取・下取り</a></p>
    </div>
    
  </div>
  
  <div class="clearfix"></div>
  <!--=- bottom ---->
  <div class="bottom">
    <div class="wrap">
      <nav class="menu-footer-container">
        <ul id="menu-footer" class="footernavi">
          <li><a href="/link/">リンク</a></li>
          <li><a href="/term/">特定商取引法に基づく表記</a></li>
          <li><a href="/privacy/">個人情報保護方針</a></li>
          <li><a href="/english/" target="_blank">English</a></li>
        </ul>
      </nav>
      <p class="copyright">This is Lucky Camera official Website. Copy Right（C）,luckycamera</p>
    </div>
  </div>
</footer><!-- end of footer -->

    <script type="text/javascript">
    /* <![CDATA[ */
      uscesL10n = {
                'ajaxurl': "http://lucky-camera.com/wp/wp-admin/admin-ajax.php",
        'post_id': "46899",
        'cart_number': "4",
        'is_cart_row': false,
        'opt_esse': new Array(  ),
        'opt_means': new Array(  ),
        'mes_opts': new Array(  ),
        'key_opts': new Array(  ), 
        'previous_url': "http://lucky-camera.com", 
        'itemRestriction': "1"
      }
    /* ]]> */
    </script>
    <script type="text/javascript" src="http://lucky-camera.com/wp/wp-content/plugins/usc-e-shop/js/usces_cart.js"></script>
            <!-- Welcart version : v1.6.1.1511042 -->
<script type="text/javascript" src="http://lucky-camera.com/wp/wp-content/plugins/contact-form-7/includes/js/jquery.form.min.js?ver=3.51.0-2014.06.20"></script>
<script type="text/javascript">
/* <![CDATA[ */
var _wpcf7 = {"loaderUrl":"http:\/\/lucky-camera.com\/wp\/wp-content\/plugins\/contact-form-7\/images\/ajax-loader.gif","sending":"\u9001\u4fe1\u4e2d ..."};
/* ]]> */
</script>
<script type="text/javascript" src="http://lucky-camera.com/wp/wp-content/plugins/contact-form-7/includes/js/scripts.js?ver=4.3"></script>

<table cellspacing="0" cellpadding="0" class="gstl_50 gssb_c" style="width: 265px; display: none; top: 2005px; left: 289px; position: absolute;"><tbody><tr><td class="gssb_f"></td><td class="gssb_e" style="width: 100%;"></td></tr></tbody></table></body>
EOS