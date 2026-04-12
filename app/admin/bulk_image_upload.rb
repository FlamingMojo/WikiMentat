# frozen_string_literal: true
ActiveAdmin.register_page 'Bulk Image Upload' do
  permit_params :wiki_bot_id, :files
  menu priority: 1, label: proc { I18n.t('active_admin.bulk_image_upload') }

  collection_action :upload, method: :post do

  end

  content title: proc { I18n.t('active_admin.bulk_image_upload.title') } do
    panel 'Info' do
      para "Welcome to the Wiki Mentat admin dashboard, #{session_user.username}."
    end

    if session_user.user_claims.pending.any?
      panel 'Check Your Wiki User Claims' do
        ul do
          session_user.user_claims.pending.map do |claim|
            li link_to(claim.claimed_username, admin_user_claim_path(claim))
          end
        end
      end
    end
  end
end
