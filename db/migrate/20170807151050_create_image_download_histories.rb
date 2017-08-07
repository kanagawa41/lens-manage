class CreateImageDownloadHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :image_download_histories do |t|
      t.references :m_shop_info, foreign_key: true
      t.references :m_lens_info, foreign_key: true
      t.string :lens_pic_url, null: false
      t.boolean :status, null: false

      t.timestamps
    end
  end
end
