ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }



  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      # リンク一覧
      column do
        panel "リンク一覧" do

          label "管理"
          ul do
            li do
              link_to("Conohaストレージ情報", conoha_list_admin_index_path)
            end
            li do
              link_to("未知の言葉をチェック", check_strange_word_admin_index_path)
            end
          end

          label "テーブル"
          ul do
            li do
              link_to("M Shop Infos", admin_m_shop_infos_path)
            end
            li do
              link_to("M Lens Infos", admin_m_lens_infos_path)
            end
            li do
              ul do
                li do
                  link_to("M Images", admin_m_images_path)
                end
                li do
                  link_to("Image Download Histories", admin_image_download_histories_path)
                end
                li do
                  link_to("Collect Warehouses", admin_collect_warehouses_path)
                end
                li do
                  link_to("Analytics LensInfos", admin_analytics_lens_infos_path)
                end
              end
            end
            li do
              link_to("M Lens Genres", admin_m_lens_genres_path)
            end
            li do
              ul do
                li do
                  link_to("M Proper Nouns", admin_m_proper_nouns_path)
                end
              end
            end
            li do
              link_to("Collect Targets", admin_collect_targets_path)
            end
            li do
              ul do
                li do
                  link_to("Collect Results", admin_collect_results_path)
                end
              end
            end
          end
        end
      end

      # タスクの実行
      column do
        panel "タスクの実行" do
          div do
            button("ワードランキングのリセット", :onclick=> "modules.activeAdmin.reset_word_ranking('ワードランキングリセット');")
          end
          div do
            '<br>'.html_safe
          end
          div do
            button("タグのリセット", :onclick=> "modules.activeAdmin.resetTags('タグリセット');")
          end
        end
      end

      # 各テーブルのデータ量
      column do
        records = ActiveRecord::Base.connection.execute("
          SELECT TABLE_NAME, TABLE_ROWS
          FROM INFORMATION_SCHEMA.TABLES
          WHERE TABLE_SCHEMA = '#{Rails.configuration.database_configuration[Rails.env]['database']}'
          order by TABLE_ROWS DESC;")

        all_models_count = records.collect{ |row| [row[0], row[1].to_i]}

        max = all_models_count.first[1].to_f
        percent = 100.00/max

        panel "テーブルのレコード数" do
          recs = ''
          all_models_count.each do |model_name, count|
            bar_size = percent*count
            bar_size = 2 if bar_size < 2 and bar_size > 0

            recs << "<div width='100px'>"
            recs << link_to("#{model_name.tableize} - #{count}", "/admin/#{model_name.tableize}") rescue nil
            recs << "<div class=\"progress progress-info\">"
            recs << "<div class=\"bar\" style=\"width: #{bar_size}%\">"
            recs << "</div>"
            recs << "</div>"
            recs << "</div>"
          end
          recs.html_safe
        end
      end
    end

    columns do
      # 各ショップの最終更新日
      column do
        panel "レンズ情報収集最終日" do
          target_ids = []

          recs = ''
          recs << "<div width='100px' style='font-weight: bold;'>"
          recs << "各ショップの最終収集日の結果。"
          recs << "</div>"
          recs << "<br>"
          recs << "<div width='100px' style='font-weight: bold;'>"
          recs << "ショップ名(ショップID): 成功数/失敗数 (全体数)"
          recs << "</div>"
           # 収集結果
          CollectResult.recent_collect_day.to_hash.each do |r|
            target_ids << r["shop_id"]
            recs << "<div width='100px'>"
            recs << "<span>#{r["shop_name"]}(#{r["shop_id"]})</span>"
            recs << "<span>：#{distance_of_time_in_words_to_now(r["updated_at"], scope: 'datetime.distance_in_words')}</span> "
            recs << "<span>"
            recs << "<label style='color: #3ec93e;'>#{r["success_num"]}</label>"
            recs << " : "
            recs << "<label style='color: red;'>#{r["fail_num"]}</label> "
            recs << "(#{r["success_num"] + r["fail_num"]})"
            recs << "</span>"
            recs << "</div>"
          end
          # 取集対象外のショップ
          MShopInfo.where(disabled: true).all.each do |r|
            target_ids << r[:id]
            recs << "<div width='100px'>"
            recs << "<span style='color: #8e9498;'>#{r[:shop_name]}(#{r[:id]})：無効中</span>"
            recs << "</div>"
          end
          # まだ収集できていないショップ
          MShopInfo.where.not(id: target_ids).all.each do |r|
            target_ids << r[:id]
            recs << "<div width='100px'>"
            recs << "<span style='color: red;'>#{r[:shop_name]}(#{r[:id]})：収集していない</span>"
            recs << "</div>"
          end
          recs.html_safe
        end
      end

      # 画像保持
      column do
        panel "画像保持" do
          query = <<-SQL
            SELECT
              mli.m_shop_info_id,
              msi.shop_name,
              sum(
                CASE WHEN mi.id is NULL THEN 1
                ELSE 0 END
              ) as not_exist_image,
              sum(
                CASE WHEN mi.id is NOT NULL THEN 1
                ELSE 0 END
              ) as exist_image
            FROM m_lens_infos AS mli
            INNER JOIN m_shop_infos AS msi ON msi.id = mli.m_shop_info_id
            LEFT OUTER JOIN m_images AS mi ON mi.m_lens_info_id = mli.id
            GROUP BY mli.m_shop_info_id
          SQL

          recs = ''
          recs << "<div width='100px' style='font-weight: bold;'>"
          recs << "各ショップの画像の取得程度を集計の結果。"
          recs << "</div>"
          recs << "<br>"
          recs << "<div width='100px' style='font-weight: bold;'>"
          recs << "ショップ名(ショップID): 画像あり/画像なし (全体数)"
          recs << "</div>"
          ActiveRecord::Base.connection.select_all(query).each do |r|
            recs << "<div width='100px'>"
            recs << "#{r["shop_name"]}(#{r["m_shop_info_id"]}): "
            recs << "<span style='color: #3ec93e;'>#{r["exist_image"]}</span>"
            recs << " / "
            recs << "<span style='color: red;'>#{r["not_exist_image"]}</span> "
            recs << "(#{r["exist_image"] + r["not_exist_image"]})"
            recs << "</div>"
          end
          recs.html_safe
        end
      end
    end

  end
end
