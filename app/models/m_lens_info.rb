class MLensInfo < ApplicationRecord
  belongs_to :m_shop_info
  has_one :m_image

  validate :none_nil_but_blank?

  # FIXME: 独自のバリデーションとして作成する
  # https://qiita.com/n-oshiro/items/4a3188be66dd0e18bae5
  def none_nil_but_blank?
    errors.add(:lens_name, "blank!") if !lens_name.nil? && lens_name.blank?
    errors.add(:lens_pic_url, "blank!") if !lens_pic_url.nil? && lens_pic_url.blank?
    errors.add(:lens_info_url, "blank!") if !lens_info_url.nil? && lens_info_url.blank?
    errors.add(:price, "blank!") if !price.nil? && price.blank?
  end
end