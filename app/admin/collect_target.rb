ActiveAdmin.register CollectTarget do
  permit_params :m_shop_info_id, :list_url, :start_page_num, :end_page_num

  active_admin_import validate: true, batch_transaction: true

  # # csvの内容をカスタマイズ
  csv :force_quotes => true, :humanize_name => false do
    column :id
    column :m_shop_info_id
    column :list_url
    column :start_page_num
    column :end_page_num
  end

end
