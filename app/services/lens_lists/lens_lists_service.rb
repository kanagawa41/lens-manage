class LensListsService  
  def self.top
    MLensInfo.where.not(lens_info_url: nil).order(created_at: :desc).limit(12).all
  end

  def self.index(query, page=1)
    MLensInfo.where(disabled: false).where("lens_name like ?", "%" + query + "%").order(created_at: :desc).page(page)
  end

end
