class LensListsService < BaseService  
  def self.top
    MLensInfo.where.not(lens_info_url: nil).order(:created_at).limit(12).all
  end

  def self.index(query)
    MLensInfo.where("lens_name like ?", "%" + query + "%").order(:created_at).limit(20).all
  end

end
