class CreateMGoodsStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :m_goods_statuses do |t|
      t.string :status_description

      t.timestamps
    end
  end
end
