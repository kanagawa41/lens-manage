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

      # 各ショップの最終更新日
      column do
        panel "レンズ情報収集最終日" do
          recs = ''
          CollectResult.to_hash.recent_collect_day.each do |r|
            recs << "<div width='100px'>"
            recs << "<span>#{r["shop_name"]}(#{r["shop_id"]})</span><span>：#{distance_of_time_in_words_to_now(r["updated_at"], scope: 'datetime.distance_in_words')}</span><span> ( <label style='color: lime;'>#{r["success_num"]}</label> : <label style='color: red;'>#{r["fail_num"]}</label> )</span>"
            recs << "</div>"
          end
          recs.html_safe
        end
      end
    end
  end
end
