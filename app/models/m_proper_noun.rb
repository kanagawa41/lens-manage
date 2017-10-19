class MProperNoun < ApplicationRecord
  belongs_to :m_lens_genre

  # タグ一覧を取得する
  def self.fetch_tags
    raw_m_proper_noun = MProperNoun.all.map do |r|
      target_str = ''
      if r.name_jp.present?
        target_str += r.name_jp
      end
      if r.name_en.present?
        target_str += ',' + r.name_en
      end
      if r.relate_name.present?
        target_str += ',' + r.relate_name
      end

      [r.id, target_str]
    end

    Hash[raw_m_proper_noun]
  end

  def self.list_group_genre
    MProperNoun.select(:id, :name_jp, :name_en).includes(:m_lens_genre).joins(:m_lens_genre).group('m_lens_genres.id').all
  end
end
