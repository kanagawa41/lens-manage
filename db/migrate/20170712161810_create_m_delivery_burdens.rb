class CreateMDeliveryBurdens < ActiveRecord::Migration[5.1]
  def change
    create_table :m_delivery_burdens do |t|
      t.string :burdender

      t.timestamps
    end
  end
end
