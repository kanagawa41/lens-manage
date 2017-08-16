ActiveAdmin.register MImage do
  permit_params :m_lens_info_id, :path

  filter :id
  filter :m_lens_info_id, as: :select, collection: MLensInfo.all.order(id: :asc).map{ |parent| [parent.lens_name, parent.id] }
  filter :path
  filter :updated_at

  ActiveAdmin.setup do |config|
    config.download_links = true
    config.download_links = [:csv]
  end

  index do
    selectable_column
    column :id do |model_name|
      link_to model_name.id, admin_m_image_path(model_name)
    end

    # # belongs_to でつながっている parent_model のリンク付きの項目
    column :m_lens_info_id do |model_name|
      link_to model_name.m_lens_info.id, admin_m_lens_info_path(model_name.m_lens_info)
    end

    # # belongs_to でつながっている parent_model のリンク付きの項目
    column :path do |model_name|
      image_tag "#{IMAGE_REFER_PATH}/#{model_name.m_lens_info.m_shop_info_id}/#{model_name.path}" if model_name.path.present?
    end

    actions defaults: false do |model|
      item 'view', admin_m_image_path(model), class: 'view_link member_link'
      item 'edit', edit_admin_m_image_path(model), class: 'edit_link member_link'
      item 'delete', admin_m_image_path(model), class: 'delete_link member_link', method: :delete, :confirm => "All grades, uploads and tracks will be deleted with this content.Are you sure you want to delete this Content?"
    end

  end

  form do |f|
    f.inputs do
      f.input :m_lens_info_id, as: :select, collection: MLensInfo.all.map { |model| [model.lens_name, model.id] }

      f.input :path
    end
    f.actions
  end

end
