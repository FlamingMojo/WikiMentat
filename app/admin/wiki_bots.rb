ActiveAdmin.register WikiBot do
  # Specify parameters which should be permitted for assignment
  permit_params :wiki_id, :guild_id, :username, :password

  # or consider:
  #
  # permit_params do
  #   permitted = [:wiki_id, :guild_id, :username, :password]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :wiki
  filter :guild
  filter :username
  filter :password
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :wiki
    column :guild
    column :username
    column :password
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :wiki
      row :guild
      row :username
      row :password
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :wiki
      f.input :guild
      f.input :username
      f.input :password
    end
    f.actions
  end
end
