ActiveAdmin.register Mission do
  # Specify parameters which should be permitted for assignment
  permit_params :title, :description, :wiki_page, :language, :map_link, :discord_post_link, :discord_post_uid, :issuer_id, :assignee_id, :guild_config_id, :status, :type, :priority, :completed_at

  # or consider:
  #
  # permit_params do
  #   permitted = [:title, :description, :wiki_page, :language, :map_link, :discord_post_link, :discord_post_uid, :issuer_id, :assignee_id, :guild_config_id, :status, :type, :priority, :completed_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  member_action :sync, method: :post do
    resource.sync_post!
    redirect_to admin_mission_path(resource), notice: 'Synced'
  end

  member_action :cancel, method: :post do
    resource.cancel
    redirect_to admin_mission_path(resource), notice: 'Cancelled'
  end

  member_action :abandon, method: :post do
    resource.abandon
    redirect_to admin_mission_path(resource), notice: 'Abandoned'
  end

  member_action :manual_submit, method: :post do
    resource.submit
    redirect_to admin_mission_path(resource), notice: 'Manually Submitted'
  end

  action_item :sync, only: :show do
    link_to 'Sync with Discord', sync_admin_mission_path(resource), method: :post, class: 'action-item-button'
  end

  action_item :cancel, only: :show do
    link_to 'Cancel Mission', cancel_admin_mission_path(resource), method: :post, class: 'action-item-button'
  end

  action_item :abandon, only: :show do
    link_to 'Abandon Mission', abandon_admin_mission_path(resource), method: :post, class: 'action-item-button'
  end

  action_item :manual_submit, only: :show do
    link_to 'Manually Submit', manual_submit_admin_mission_path(resource), method: :post, class: 'action-item-button'
  end

  # Add or remove filters to toggle their visibility
  filter :id
  filter :title
  filter :description
  filter :wiki_page
  filter :language
  filter :map_link
  filter :discord_post_link
  filter :discord_post_uid
  filter :issuer
  filter :assignee
  filter :guild_config
  filter :status
  filter :type
  filter :priority
  filter :completed_at
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :title
    column :description
    column :wiki_page
    column :language
    column :map_link
    column :discord_post_link
    column :discord_post_uid
    column :issuer
    column :assignee
    column :guild_config
    column :status
    column :type
    column :priority
    column :completed_at
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :title
      row :description
      row :wiki_page
      row :language
      row :map_link
      row :discord_post_link
      row :discord_post_uid
      row :issuer
      row :assignee
      row :guild_config
      row :status
      row :type
      row :priority
      row :completed_at
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :title
      f.input :description
      f.input :wiki_page
      f.input :language
      f.input :map_link
      f.input :discord_post_link
      f.input :discord_post_uid
      f.input :issuer
      f.input :assignee
      f.input :guild_config
      f.input :status, as: :string
      f.input :type, as: :string
      f.input :priority, as: :string
      f.input :completed_at
    end
    f.actions
  end
end
