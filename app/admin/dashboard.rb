ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
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

    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end
  end # content
end
