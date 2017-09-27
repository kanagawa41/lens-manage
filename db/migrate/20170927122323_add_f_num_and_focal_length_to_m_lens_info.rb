class AddFNumAndFocalLengthToMLensInfo < ActiveRecord::Migration[5.1]
  def change
    add_column :m_lens_infos, :f_num, :string, null: true, default: nil, after: :m_shop_info_id
    add_column :m_lens_infos, :focal_length, :string, null: true, default: nil, after: :f_num
  end
end
