json.extract! collect_target, :id, :m_shop_info_id, :list_url, :start_page_num, :end_page_num, :created_at, :updated_at
json.url collect_target_url(collect_target, format: :json)
