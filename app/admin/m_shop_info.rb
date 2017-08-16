ActiveAdmin.register MShopInfo do
  permit_params :shop_name, :shop_url, :disabled
  actions :all

  filter :shop_name
  filter :shop_url
  filter :disabled
  filter :updated_at

  ActiveAdmin.setup do |config|
    config.download_links = true
    config.download_links = [:csv]
  end

  index do
    selectable_column
  
    column :id
    column :shop_name
    column :shop_url
    column :disabled

    actions defaults: false do |model|
      item 'view', admin_m_shop_info_path(model), class: 'view_link member_link'
      item 'edit', edit_admin_m_shop_info_path(model), class: 'edit_link member_link'
      item 'delete', admin_m_shop_info_path(model), class: 'delete_link member_link', method: :delete, :confirm => "All grades, uploads and tracks will be deleted with this content.Are you sure you want to delete this Content?"
    end
  end

  form do |f|
    f.inputs do
      f.input :shop_name
      f.input :shop_url
      f.input :disabled
    end
    f.actions
  end

end
