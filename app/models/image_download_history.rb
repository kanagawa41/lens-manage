class ImageDownloadHistory < ApplicationRecord
  belongs_to :m_shop_info
  belongs_to :m_lens_info
end
