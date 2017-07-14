class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :user_name
      t.integer :good_rating
      t.integer :normal_rating
      t.integer :bad_rating
      t.text :description

      t.timestamps
    end
  end
end
