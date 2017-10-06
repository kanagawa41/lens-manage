class CollectResult < ApplicationRecord
  belongs_to :m_shop_info

  # ショップ毎の最新収集日を取得
  def self.recent_collect_day
    ActiveRecord::Base.connection.select_all("
      SELECT msi.id as shop_id, msi.shop_name, cr.success_num, cr.fail_num, cr.updated_at
      FROM collect_results AS cr
      INNER JOIN m_shop_infos AS msi
      ON msi.id = cr.m_shop_info_id
      WHERE NOT EXISTS (
        SELECT 1
        FROM collect_results AS scr
        WHERE cr.m_shop_info_id = scr.m_shop_info_id
        AND cr.updated_at < scr.updated_at
      );
    ")
  end

end
