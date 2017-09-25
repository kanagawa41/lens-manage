module LensListsService
  module_function
  
  def top
    MLensInfo.where.not(lens_info_url: nil).order(created_at: :desc).limit(12).all
  end

  def index(query, page)
    if query.present?
      result_num = MLensInfo.where(disabled: false).where("lens_name like ?", "%" + query + "%").count
      SearchHistory.create(search_char: query, result_num: result_num)

      MLensInfo.where(disabled: false).where("lens_name like ?", "%" + query + "%").order(created_at: :desc).page(page)
    else # 指定がなかった場合
      MLensInfo.where(disabled: false).order(created_at: :desc).page(page)
    end
  end

  def open_info(lens_info_id)
    TransitionHistory.create(m_lens_info_id: lens_info_id)

    MLensInfo.find(lens_info_id)
  end

end
