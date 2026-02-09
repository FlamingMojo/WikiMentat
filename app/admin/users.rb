ActiveAdmin.register User do
  # Specify parameters which should be permitted for assignment
  permit_params :discord_uid, :username, :display_name, :mentat_role

  # or consider:
  #
  # permit_params do
  #   permitted = [:discord_uid, :username, :display_name, :mentat_role]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :discord_uid
  filter :username
  filter :display_name
  filter :mentat_role
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :discord_uid
    column :username
    column :display_name
    column :mentat_role
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :discord_uid
      row :username
      row :display_name
      row :mentat_role
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :discord_uid
      f.input :username
      f.input :display_name
      f.input :mentat_role
    end
    f.actions
  end
end
