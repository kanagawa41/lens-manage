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
    column :path

  end

  form do |f|
    f.inputs do
      f.input :m_lens_info_id, as: :select, collection: MLensInfo.all.map { |model| [model.lens_name, model.id] }

      f.input :path
    end
    f.actions
  end

end
