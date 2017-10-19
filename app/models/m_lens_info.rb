class MLensInfo < ApplicationRecord
  belongs_to :m_shop_info
  has_one :m_image
  has_one :analytics_lens_info

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
  def self.set_search_conditions(query, f_num, focal_length, tag_id=nil)
    m_lens_info = MLensInfo.includes(:analytics_lens_info, :m_image, :m_shop_info).left_joins(:analytics_lens_info).where(disabled: false)
    if query.present?
      m_lens_info = m_lens_info.where("CONCAT(lens_name, ranking_words) like ?", "%" + query + "%")
    end
    if f_num.present?
      m_lens_info = m_lens_info.where("f_num like ?", "%" + f_num + "%")
    end
    if focal_length.present?
      m_lens_info = m_lens_info.where("focal_length like ?", "%" + focal_length + "%")
    end
    if tag.present?
      m_lens_info = m_lens_info.where("CONCAT(',', tags, ',') like ?", "%," + tag_id + ",%")
    end
    m_lens_info
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