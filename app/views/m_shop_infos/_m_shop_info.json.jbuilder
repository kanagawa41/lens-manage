json.extract! m_shop_info, :id, :shop_name, :shop_url, :created_at, :updated_at
json.url m_shop_info_url(m_shop_info, format: :json)
