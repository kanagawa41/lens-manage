namespace :test do
  desc "テスト"
  require 'capybara/poltergeist'
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