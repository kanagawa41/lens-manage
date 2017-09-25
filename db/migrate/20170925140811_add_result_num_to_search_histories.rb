class AddResultNumToSearchHistories < ActiveRecord::Migration[5.1]
  def change
    add_column :search_histories, :result_num, :integer, null: true, default: 0, after: :search_char
  end
end
