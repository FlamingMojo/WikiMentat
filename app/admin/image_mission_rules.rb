ActiveAdmin.register ImageMissionRule do
  # Specify parameters which should be permitted for assignment
  permit_params :image_rule_id, :mission_id

  # or consider:
  #
  # permit_params do
  #   permitted = [:image_rule_id, :mission_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :image_rule
  filter :mission
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :image_rule
    column :mission
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :image_rule
      row :mission
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :image_rule
      f.input :mission
    end
    f.actions
  end
end
