class CreateUrlGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :url_groups do |t|
      t.string :tag

      t.timestamps
    end
  end
end
