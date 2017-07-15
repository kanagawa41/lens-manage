class CategoryPage < ApplicationRecord
  belongs_to :m_category, optional: true
end
