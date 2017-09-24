class LensListsService  
  def self.top
    MLensInfo.where.not(lens_info_url: nil).order(created_at: :desc).limit(12).all
  end

  def self.index(query, page=1)
    SearchHistory.create(search_char: query)

    MLensInfo.where(disabled: false).where("lens_name like ?", "%" + query + "%").order(created_at: :desc).page(page)
  end

  def self.open_info(lens_info_id)
    TransitionHistory.create(m_lens_info_id: lens_info_id)

    MLensInfo.find(lens_info_id)
  end

end
