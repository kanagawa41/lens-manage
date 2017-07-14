class CreateMPrefectures < ActiveRecord::Migration[5.1]
  def change
    create_table :m_prefectures do |t|
      t.string :prefecture_name

      t.timestamps
    end
  end
end
