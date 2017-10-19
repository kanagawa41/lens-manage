ActiveAdmin.register MProperNoun do
  config.per_page = 1000

  permit_params :m_lens_genre_id, :name_jp, :name_en, :relate_name

  active_admin_import validate: true, batch_transaction: true

  filter :m_lens_genre_id, as: :select, collection: MLensGenre.all.order(id: :asc).map{ |model| ["#{model.genre_name}(#{model.id})", model.id] }
  filter :name_jp
  filter :name_en
  filter :relate_name

  # # csvの内容をカスタマイズ
  csv :force_quotes => true, :humanize_name => false do
    column :id
    column :m_lens_genre_id
    column :name_jp
    column :name_en
    column :relate_name
  end

  index do
    selectable_column
    column :id do |model|
      link_to model.id, admin_m_proper_noun_path(model)
    end

    column :m_lens_genre_id do |model|
      link_to "#{model.m_lens_genre.genre_name}(#{model.m_lens_genre_id})", admin_m_lens_genre_path(model.m_lens_genre)
    end

    column :name_jp
    column :name_en
    column :relate_name

    actions defaults: false do |model|
      item 'view', admin_m_proper_noun_path(model), class: 'view_link member_link'
      item 'edit', edit_admin_m_proper_noun_path(model), class: 'edit_link member_link'
      item 'delete', admin_m_proper_noun_path(model), class: 'delete_link member_link', method: :delete, :confirm => "All grades, uploads and tracks will be deleted with this content.Are you sure you want to delete this Content?"
    end
  end

  form do |f|
    f.inputs do
      f.input :m_lens_genre_id, as: :select, collection: MLensGenre.all.order(id: :asc).map{ |model| ["#{model.genre_name}(#{model.id})", model.id] }
      f.input :name_jp
      f.input :name_en
      f.input :relate_name
    end
    f.actions
  end

end