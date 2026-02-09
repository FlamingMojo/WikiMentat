# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    panel "Info" do
      para "Welcome to the Wiki Mentat admin dashboard, #{session_user.username}."
    end

    if session_user.user_claims.any?
      panel "Check Your Wiki User Claims" do
        ul do
          session_user.user_claims.map do |claim|
            li link_to(claim.wiki_username, admin_user_claims_path(claim))
          end
        end
      end
    end
  end # content
end
