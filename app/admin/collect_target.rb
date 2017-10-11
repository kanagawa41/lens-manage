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

  index do
    selectable_column
    column :id do |model_name|
      link_to model_name.id, admin_collect_target_path(model_name)
    end

    column :m_shop_info_id do |model_name|
      link_to model_name.m_shop_info.shop_name, admin_m_shop_info_path(model_name.m_shop_info)
    end

    column :list_url
    column :start_page_num
    column :end_page_num
    column :created_at

    actions defaults: false do |model|
      item 'view', admin_collect_target_path(model), class: 'view_link member_link'
      item 'edit', edit_admin_collect_target_path(model), class: 'edit_link member_link'
      item 'delete', admin_collect_target_path(model), class: 'delete_link member_link', method: :delete, :confirm => "All grades, uploads and tracks will be deleted with this content.Are you sure you want to delete this Content?"
    end
  end

end
