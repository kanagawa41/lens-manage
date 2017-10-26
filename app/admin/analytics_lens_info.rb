ActiveAdmin.register AnalyticsLensInfo do
  permit_params :m_lens_info_id, :google_related_words, :google_match_words, :done_flag

  # # csvの内容をカスタマイズ
  csv :force_quotes => false, :humanize_name => false do
    column :id
    column :google_related_words
    column :google_match_words
    column :ranking_words
    column :done_flag
  end

  index do
    selectable_column

    column :id
    column :m_lens_info_id do |model|
      link_to model.m_lens_info.lens_name, admin_m_lens_info_path(model.m_lens_info)
    end


    column :google_related_words
    column :google_match_words
    column :ranking_words
    column :done_flag
    column :created_at

    actions defaults: false do |model|
      item 'view', admin_collect_target_path(model), class: 'view_link member_link'
      item 'edit', edit_admin_collect_target_path(model), class: 'edit_link member_link'
      item 'delete', admin_collect_target_path(model), class: 'delete_link member_link', method: :delete, :confirm => "All grades, uploads and tracks will be deleted with this content.Are you sure you want to delete this Content?"
    end
  end

  form do |f|
    f.inputs do
      f.input :m_lens_info_id, as: :select, collection: MLensInfo.all.map { |model| [model.lens_name, model.id] }
      f.input :google_related_words
      f.input :google_match_words
      f.input :ranking_words
      f.input :done_flag
    end
    f.actions
  end

end