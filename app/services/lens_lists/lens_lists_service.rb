module LensListsService
  # include BaseService
  module_function

  def top
    MLensInfo.where.not(lens_info_url: nil).order(created_at: :desc).limit(12).all
  end

  def index(params, page)
    query = params[:q]
    min_price = params[:min_price]
    max_price = params[:max_price]
    tag = params[:tag]

    if params[:tag].present?
      m_proper_noun = MProperNoun.search_tag(tag)
      return Kaminari.paginate_array([]).page(0) unless m_proper_noun.present?
      tag_id = m_proper_noun.id
    end

    if query.present? || min_price.present? || max_price.present? || tag_id.present?
      result_num = MLensInfo.set_search_conditions(query, min_price, max_price, tag_id).count
      SearchHistory.create(
        search_char: query,
        result_num: result_num,
        search_condition_json: { min_price: min_price, max_price: max_price, tag: tag }.to_json
      )

      return Kaminari.paginate_array([]).page(0) if result_num == 0

      # 日付が新し、情報が古くない順
      MLensInfo.set_search_conditions(query, min_price, max_price, m_proper_noun.id).order(created_at: :desc, old_flag: :asc).page(page)

    else # 指定がなかった場合
      MLensInfo.includes_for_search.where(disabled: false).order(created_at: :desc, old_flag: :asc).page(page)
    end
  end

  def open_info(lens_info_id)
    TransitionHistory.create(m_lens_info_id: lens_info_id)

    MLensInfo.find(lens_info_id)
  end

  def tag(page, m_proper_noun)
    result_num = MLensInfo.set_search_conditions(nil, nil, nil, m_proper_noun.id).count
    SearchHistory.create(
      search_char: nil,
      result_num: result_num,
      search_condition_json: { min_price: nil, max_price: nil, tag: [m_proper_noun.name_jp, m_proper_noun.name_en] }.to_json
    )

    return Kaminari.paginate_array([]).page(0) if result_num == 0

    MLensInfo.set_search_conditions(nil, nil, nil, m_proper_noun.id).order(created_at: :desc).page(page)
  end

  def category
    # タグ一覧を取得する
    MProperNoun.list_group_genre
  end

  def _footer
    # タグ一覧を取得する
    MProperNoun.list_group_genre
  end
end
