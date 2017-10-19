module LensListsService
  # include BaseService
  module_function

  def top
    MLensInfo.where.not(lens_info_url: nil).order(created_at: :desc).limit(12).all
  end

  def index(params, page)
    query = params[:q]
    f_num = params[:f_num]
    focal_length = params[:focal_length]
    if query.present? || f_num.present? || focal_length.present?
      result_num = MLensInfo.set_search_conditions(query, f_num, focal_length).count
      SearchHistory.create(
        search_char: query,
        result_num: result_num,
        search_condition_json: { f_num: f_num, focal_length: focal_length }.to_json
      )

      return Kaminari.paginate_array([]).page(0) if result_num == 0

      MLensInfo.set_search_conditions(query, f_num, focal_length).order(created_at: :desc).page(page)
    else # 指定がなかった場合
      MLensInfo.where(disabled: false).order(created_at: :desc).page(page)
    end
  end

  def open_info(lens_info_id)
    TransitionHistory.create(m_lens_info_id: lens_info_id)

    MLensInfo.find(lens_info_id)
  end

  def tag(params, page, m_proper_noun)
    result_num = MLensInfo.set_search_conditions(query, f_num, focal_length, m_proper_noun.id).count
    SearchHistory.create(
      search_char: query,
      result_num: result_num,
      search_condition_json: { f_num: nil, focal_length: nil, tag: tag }.to_json
    )

    return Kaminari.paginate_array([]).page(0) if result_num == 0

    MLensInfo.set_search_conditions(query, f_num, focal_length).order(created_at: :desc).page(page)
  end

  def footer
    # タグ一覧を取得する
    MProperNoun.list_group_genre
  end
end
