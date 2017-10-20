ActiveAdmin.register MLensInfo do
  permit_params :lens_name, :lens_pic_url, :lens_info_url, :stock_state, :price, :m_shop_info_id, :disabled, :memo, :tags, :designation, :maker
  actions :all

  filter :id
  filter :lens_name
  filter :lens_pic_url
  filter :lens_info_url
  filter :stock_state
  filter :price
  filter :m_shop_info_id, as: :select, collection: MShopInfo.all.order(id: :asc).map{ |parent| ["#{parent.shop_name}(#{parent.id})", parent.id] }
  filter :f_num
  filter :focal_length
  filter :disabled
  filter :old_flag

  index do
    selectable_column
    column :id do |model|
      link_to model.id, admin_m_lens_info_path(model)
    end

    column :lens_name
    column :lens_pic_url
    column :lens_info_url
    column :stock_state
    column :price

    # # belongs_to でつながっている parent_model のリンク付きの項目
    column :m_shop_info_id do |model|
      link_to "#{model.m_shop_info.shop_name}(#{model.m_shop_info_id})", admin_m_shop_info_path(model.m_shop_info)
    end

    column :f_num
    column :focal_length
    column :tags
    column :designation
    column :maker

    column :exist_image do |model|
      if m_image = MImage.where(m_lens_info_id: model.id).first
        link_to "○", admin_m_image_path(m_image)
      else
        label "×"
      end
    end

    column :disabled
    column :old_flag
    column :created_at
    column :updated_at

    actions defaults: false do |model|
      item 'view', admin_m_lens_info_path(model), class: 'view_link member_link'
      item 'edit', edit_admin_m_lens_info_path(model), class: 'edit_link member_link'
      item 'delete', admin_m_lens_info_path(model), class: 'delete_link member_link', method: :delete, :confirm => "All grades, uploads and tracks will be deleted with this content.Are you sure you want to delete this Content?"
    end
  end

  form do |f|
    f.inputs do
      f.input :lens_name
      f.input :lens_pic_url
      f.input :lens_info_url
      f.input :stock_state
      f.input :price
      f.input :m_shop_info_id, as: :select, collection: MShopInfo.all.map { |model| [model.shop_name, model.id] }
      f.input :f_num
      f.input :focal_length
      f.input :tags
      f.input :designation
      f.input :maker
      f.input :disabled
      f.input :memo
      f.input :old_flag
    end
    f.actions
  end
end
