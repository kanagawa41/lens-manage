AdminUser.create!([
  {email: "test@gmail.com", encrypted_password: "test", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: "2017-08-10 01:48:56", sign_in_count: 1, current_sign_in_at: nil, last_sign_in_at: nil, current_sign_in_ip: nil, last_sign_in_ip: nil},
  {email: "admin@example.com", encrypted_password: "$2a$11$tG7CALVJ3P/YEehibIijouCV1Z1390iHhxlEjc5RhrBzB9dfYJI86", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: "2017-08-16 09:28:02", sign_in_count: 12, current_sign_in_at: "2017-09-13 11:35:13", last_sign_in_at: "2017-08-27 12:51:31", current_sign_in_ip: "192.168.33.1", last_sign_in_ip: "192.168.33.1"}
])

CollectTarget.create!([
  {m_shop_info_id: 1, list_url: "http://cameranonaniwa.jp/shop/goods/search.aspx?p=[$page]&ps=50&pb_search=x&search=x&pb_tree=B0A5", start_page_num: 1, end_page_num: 33},
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
  {m_shop_info_id: 5, list_url: "https://doppietta-tokyo.jp/collections/non-leica-lens", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 6, list_url: "http://www.oosawacamera.com/new.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 6, list_url: "http://www.oosawacamera.com/c-mount.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 6, list_url: "http://www.oosawacamera.com/M42.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 6, list_url: "http://www.oosawacamera.com/leica.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 6, list_url: "http://www.oosawacamera.com/nikon.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 6, list_url: "http://www.oosawacamera.com/canon.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 6, list_url: "http://www.oosawacamera.com/olympus.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 6, list_url: "http://www.oosawacamera.com/ohter.html", start_page_num: 1, end_page_num: 1},
  {m_shop_info_id: 6, list_url: "http://www.oosawacamera.com/import.html", start_page_num: 1, end_page_num: 1}
])

MShopInfo.create!([
  {shop_name: "レモン社", letter_code: "LEM", shop_url: "http://cameranonaniwa.jp", disabled: false},
  {shop_name: "クラシックカメラ　モリッツ", letter_code: "CCM", shop_url: "http://www.moritz.co.jp", disabled: false},
  {shop_name: "フォトベルゼ", letter_code: "FBZ", shop_url: "http://fotoborse.blog.jp", disabled: false},
  {shop_name: "Foto:Mutori", letter_code: "FMR", shop_url: "http://fotomutori.com", disabled: false},
  {shop_name: "ドッピエッタトーキョー", letter_code: "DET", shop_url: "https://doppietta-tokyo.jp", disabled: false},
  {shop_name: "大沢カメラ", letter_code: "OSC", shop_url: "http://www.oosawacamera.com/", disabled: false}
])
