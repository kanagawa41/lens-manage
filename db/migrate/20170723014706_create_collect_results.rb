class CreateCollectResults < ActiveRecord::Migration[5.1]
  def change
    create_table :collect_results do |t|
      t.references :m_shop_info, foreign_key: true
      t.boolean :is_done

      t.timestamps
    end
  end
end
