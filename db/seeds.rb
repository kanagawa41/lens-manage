AdminUser.create!(:email => 'admin@example.com', :password => 'password')
MShopInfo.create!([
  {shop_name: "レモン社", letter_code: "LEM", shop_url: "http://cameranonaniwa.jp", disabled: true},
  {shop_name: "クラシックカメラ　モリッツ", letter_code: "CCM", shop_url: "http://www.moritz.co.jp", disabled: true},
  {shop_name: "フォトベルゼ", letter_code: "FBZ", shop_url: "http://fotoborse.blog.jp", disabled: true},
  {shop_name: "Foto:Mutori", letter_code: "FMR", shop_url: "http://fotomutori.com", disabled: true},
  {shop_name: "ドッピエッタトーキョー", letter_code: "DET", shop_url: "https://doppietta-tokyo.jp", disabled: true}
])
CollectTarget.create!([
  {m_shop_info_id: 1, list_url: "http://cameranonaniwa.jp/shop/goods/search.aspx?p=[$page]&ps=50&pb_search=x&search=x&pb_tree=B0A5", start_page_num: 1, end_page_num: 34},
  {m_shop_info_id: 2, list_url: "http://www.moritz.co.jp/alpa.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 2, list_url: "http://www.moritz.co.jp/zeiss.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 2, list_url: "http://www.moritz.co.jp/m42lens.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 2, list_url: "http://www.moritz.co.jp/zeiss.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 2, list_url: "http://www.moritz.co.jp/kodak.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 2, list_url: "http://www.moritz.co.jp/gaikoku.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 2, list_url: "http://www.moritz.co.jp/nikon.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 2, list_url: "http://www.moritz.co.jp/pentax.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 2, list_url: "http://www.moritz.co.jp/kyocera.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 2, list_url: "http://www.moritz.co.jp/miranda.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 2, list_url: "http://www.moritz.co.jp/kokusan.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 3, list_url: "http://fotoborse.blog.jp/?p=[$page]", start_page_num: 1, end_page_num: 50},
  {m_shop_info_id: 4, list_url: "http://fotomutori.com/blog/", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 5, list_url: "https://doppietta-tokyo.jp/collections/leica-m/leica-m-lens", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 5, list_url: "https://doppietta-tokyo.jp/collections/leica-l", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 5, list_url: "https://doppietta-tokyo.jp/collections/smart-collection-6", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 5, list_url: "https://doppietta-tokyo.jp/collections/non-leica-lens", start_page_num: 1, end_page_num: 1}
])