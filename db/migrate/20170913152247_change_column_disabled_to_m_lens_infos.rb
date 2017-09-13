class ChangeColumnDisabledToMLensInfos < ActiveRecord::Migration[5.1]
  def change
    change_column_default :m_lens_infos, :disabled, false
  end
end
