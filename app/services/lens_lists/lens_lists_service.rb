class LensListsService  
  def self.top
    MLensInfo.where.not(lens_info_url: nil).order(:created_at).limit(12).all
  end

  def self.index(query, page)
    MLensInfo.where("lens_name like ?", "%" + query + "%").order(:created_at).page(page)
  end

end
