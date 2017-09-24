class CreateSearchHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :search_histories do |t|
      t.string :search_char
      t.string :search_condition_json

      t.timestamps
    end
  end
end
