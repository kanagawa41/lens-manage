MShopInfo.create!([
  {shop_name: nil, shop_url: nil},
  {shop_name: "レモン社", shop_url: "http://cameranonaniwa.jp"}
])
CollectTarget.create!([
  {m_shop_info_id: 1, list_url: "http://cameranonaniwa.jp/shop/goods/search.aspx?p=[$page]&ps=50&pb_search=x&search=x&pb_tree=B0A5", page_num: nil, is_done: false}
])
