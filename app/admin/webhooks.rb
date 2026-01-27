ActiveAdmin.register Webhook do
  # Specify parameters which should be permitted for assignment
  permit_params :wiki_id, :wiki_user_id, :message_id, :payload, :hook_type

  # or consider:
  #
  # permit_params do
  #   permitted = [:wiki_id, :wiki_user_id, :message_id, :payload, :hook_type]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :wiki
  filter :wiki_user
  filter :message
  filter :payload
  filter :hook_type
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :wiki
    column :wiki_user
    column :message
    column :payload
    column :hook_type
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :wiki
      row :wiki_user
      row :message
      row :payload
      row :hook_type
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :wiki
      f.input :wiki_user
      f.input :message
      f.input :payload
      f.input :hook_type
    end
    f.actions
  end
end
