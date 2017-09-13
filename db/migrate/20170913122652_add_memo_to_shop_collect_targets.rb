class AddMemoToShopCollectTargets < ActiveRecord::Migration[5.1]
  def change
    add_column :m_lens_infos, :memo, :string, :null => true, default: nil, after: :created_at
  end
end
