ActiveAdmin.register CollectTarget do
  permit_params :m_shop_info_id, :list_url, :start_page_num, :end_page_num

  csv humanize_name: false do
    column :id
    column :m_shop_info_id
    column :list_url
    column :start_page_num
    column :end_page_num
  end

  active_admin_importable do |model_c, hash|
    if model_c.exists?(hash[:id])
      @model = model_c.find(hash[:id])
      @model.attributes = hash
      @model.save!
    else
      model_c.create!(hash)
    end
  end
end
