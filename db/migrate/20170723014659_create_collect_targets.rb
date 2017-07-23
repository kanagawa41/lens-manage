class CreateCollectTargets < ActiveRecord::Migration[5.1]
  def change
    create_table :collect_targets do |t|
      t.references :m_shop_info, foreign_key: true
      t.string :list_url
      t.boolean :is_done

      t.timestamps
    end
  end
end
