ActiveAdmin.register RewardType do
  # Specify parameters which should be permitted for assignment
  permit_params :guild_config_id, :name, :active, :config, :redemption_instructions

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :guild_config
  filter :name
  filter :active
  filter :redemption_instructions
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :guild_config
    column :name
    column :active
    column :config
    column :redemption_instructions
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
      row :active
      row :config
      row :redemption_instructions
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
      f.input :active
      f.input :config
      f.input :redemption_instructions
    end
    f.actions
  end
end
