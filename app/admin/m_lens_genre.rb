ActiveAdmin.register MLensGenre do
  permit_params :group_no, :genre_name

  active_admin_import validate: true, batch_transaction: true

  # # csvの内容をカスタマイズ
  csv :force_quotes => true, :humanize_name => false do
    column :id
    column :group_no
    column :genre_name
  end
end