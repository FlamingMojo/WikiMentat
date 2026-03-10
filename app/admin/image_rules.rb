ActiveAdmin.register ImageRule do
  # Specify parameters which should be permitted for assignment
  permit_params :guild_config_id, :name, :min_width, :min_height, :max_width, :max_height, :ratio, :format

  # or consider:
  #
  # permit_params do
  #   permitted = [:guild_config_id, :name, :min_width, :min_height, :max_width, :max_height, :ratio, :format]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :guild_config
  filter :name
  filter :min_width
  filter :min_height
  filter :max_width
  filter :max_height
  filter :ratio
  filter :format
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :guild_config
    column :name
    column :min_width
    column :min_height
    column :max_width
    column :max_height
    column :ratio
    column :format
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :guild_config
      row :name
      row :min_width
      row :min_height
      row :max_width
      row :max_height
      row :ratio
      row :format
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :guild_config
      f.input :name
      f.input :min_width
      f.input :min_height
      f.input :max_width
      f.input :max_height
      f.input :ratio
      f.input :format
    end
    f.actions
  end
end
