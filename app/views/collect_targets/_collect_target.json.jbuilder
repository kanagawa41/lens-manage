json.extract! collect_target, :id, :m_shop_info_id, :list_url, :page_num, :is_done, :created_at, :updated_at
json.url collect_target_url(collect_target, format: :json)
