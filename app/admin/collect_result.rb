ActiveAdmin.register CollectResult do
  permit_params :m_shop_info_id, :success_num, :fail_num

  filter :m_shop_info_id, as: :select, collection: MShopInfo.all.order(id: :asc).map{ |parent| ["#{parent.shop_name}(#{parent.id})", parent.id] }

  index do
    selectable_column
    column :id do |model|
      link_to model.id, admin_collect_result_path(model)
    end

    column :m_shop_info_id do |model|
      link_to model.m_shop_info.shop_name, admin_m_shop_info_path(model.m_shop_info)
    end

    column :success_num do |model|
    	if model.success_num == 0
      	content_tag(:p, model.success_num, :style => 'color:red')
      else
    		model.success_num
      end
    end

    column :fail_num do |model|
    	# 失敗数が半数以上の場合
    	if (model.success_num + model.fail_num) / 2 < model.fail_num
      	content_tag(:p, model.fail_num, :style => 'color:red')
      else
    		model.fail_num
      end
    end
    column :created_at

    actions defaults: false do |model|
      item 'view', admin_m_lens_info_path(model), class: 'view_link member_link'
      item 'edit', edit_admin_m_lens_info_path(model), class: 'edit_link member_link'
      item 'delete', admin_m_lens_info_path(model), class: 'delete_link member_link', method: :delete, :confirm => "All grades, uploads and tracks will be deleted with this content.Are you sure you want to delete this Content?"
    end
  end
end
