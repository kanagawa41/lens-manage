ActiveAdmin.register CollectWarehouse do

  # # csvの内容をカスタマイズ
  csv :force_quotes => false, :humanize_name => false do
    column :id
    column :metadata
  end

end