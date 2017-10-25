class MLensInfo < ApplicationRecord
  belongs_to :m_shop_info
  has_one :m_image
  has_one :analytics_lens_info
  belongs_to :designation_m_proper_noun, :class_name => 'MProperNoun', :foreign_key => 'designation', required: false
  belongs_to :maker_m_proper_noun, :class_name => 'MProperNoun', :foreign_key => 'maker', required: false

  validate :none_nil_but_blank?

  # FIXME: 独自のバリデーションとして作成する
  # https://qiita.com/n-oshiro/items/4a3188be66dd0e18bae5
  def none_nil_but_blank?
    errors.add(:lens_name, "blank!") if !lens_name.nil? && lens_name.blank?
    errors.add(:lens_pic_url, "blank!") if !lens_pic_url.nil? && lens_pic_url.blank?
    errors.add(:lens_info_url, "blank!") if !lens_info_url.nil? && lens_info_url.blank?
    errors.add(:price, "blank!") if !price.nil? && price.blank?
  end

  # 条件検索を行う
  def self.set_search_conditions(query, min_price, max_price, tag_id=nil)
    m_lens_info = MLensInfo.includes_for_search.left_joins(:analytics_lens_info).where(disabled: false)
    if query.present?
      m_lens_info = m_lens_info.where("CONCAT(lens_name, ranking_words) like ?", "%" + query + "%")
    end
    if min_price.present?
      m_lens_info = m_lens_info.where("price >= ? ", min_price.to_i)
    end
    if max_price.present?
      m_lens_info = m_lens_info.where("price <= ? ", max_price.to_i)
    end
    if tag_id.present?
      m_lens_info = m_lens_info.where("CONCAT(',', tags, ',') like ?", "%," + tag_id.to_s + ",%")
    end
    m_lens_info
  end

  def self.includes_for_search
    MLensInfo.includes(:analytics_lens_info, :m_image, :m_shop_info, :designation_m_proper_noun, :maker_m_proper_noun)
  end

  # F値一覧を取得する
  def self.find_f_nums
    MLensInfo.select(:f_num).where.not(f_num: [nil, '']).where(disabled: false).group(:f_num).order(:f_num).all
  end

  # 焦点距離一覧を取得する
  def self.find_focal_lengthes
    MLensInfo.select(:focal_length).where.not(focal_length: [nil, '']).where(disabled: false).group(:focal_length).all
  end

  private

end