class CreateReserves < ActiveRecord::Migration[5.1]
  def change
    create_table :reserves do |t|
      t.string :url
      t.time :wait_time

      t.timestamps
    end

    add_reference :reserves, :url_group, foreign_key: true
  end
end
