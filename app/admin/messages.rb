ActiveAdmin.register Message do
  # Specify parameters which should be permitted for assignment
  permit_params :channel_id, :webhook_id, :discord_uid, :content, :message_type

  # or consider:
  #
  # permit_params do
  #   permitted = [:channel_id, :webhook_id, :discord_uid, :content, :message_type]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :channel
  filter :webhook
  filter :discord_uid
  filter :content
  filter :message_type
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :channel
    column :webhook
    column :discord_uid
    column :content
    column :message_type
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :channel
      row :webhook
      row :discord_uid
      row :content
      row :message_type
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :channel
      f.input :webhook
      f.input :discord_uid
      f.input :content
      f.input :message_type
    end
    f.actions
  end
end
