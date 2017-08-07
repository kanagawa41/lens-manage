class CreateMImages < ActiveRecord::Migration[5.1]
  def change
    create_table :m_images do |t|
      t.references :m_lens_info, foreign_key: true
      t.string :path, index: { unique: true }, null: false 

      t.timestamps
    end
  end
end
