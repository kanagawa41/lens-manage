ActiveAdmin.register CollectTarget do
  permit_params :m_shop_info_id, :list_url, :start_page_num, :end_page_num
end
