ActiveAdmin.register Wiki do
  # Specify parameters which should be permitted for assignment
  permit_params :url, :api_path, :wiki_prefix

  # or consider:
  #
  # permit_params do
  #   permitted = [:guild_id, :url, :api_path, :wiki_prefix]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :url
  filter :api_path
  filter :wiki_prefix
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :url
    column :api_path
    column :wiki_prefix
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :url
      row :api_path
      row :wiki_prefix
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :url
      f.input :api_path
      f.input :wiki_prefix
    end
    f.actions
  end
end
