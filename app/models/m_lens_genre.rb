class MLensGenre < ApplicationRecord

  has_one :m_proper_noun

  # 指定の固有IDがレンズの呼称か？
  def self.is_designation?(proper_noun_id)
    MLensGenre.joins(:m_proper_noun).where(group_no: 2).where('m_proper_nouns.id = ?', proper_noun_id).count > 0
  end

  # 指定の固有IDがメーカ名か？
  def self.is_maker?(proper_noun_id)
    MLensGenre.joins(:m_proper_noun).where(group_no: 1).where('m_proper_nouns.id = ?', proper_noun_id).count > 0
  end

end
