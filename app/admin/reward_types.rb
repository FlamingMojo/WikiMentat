ActiveAdmin.register RewardType do
  # Specify parameters which should be permitted for assignment
  permit_params :guild_config_id, :reward_key, :name, :active, :threshold, :threshold_type, :redemption_instructions

  # or consider:
  #
  # permit_params do
  #   permitted = [:guild_config_id, :reward_key, :name, :active, :threshold, :threshold_type, :redemption_instructions]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :guild_config
  filter :reward_key
  filter :name
  filter :active
  filter :threshold
  filter :threshold_type
  filter :redemption_instructions
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :guild_config
    column :reward_key
    column :name
    column :active
    column :threshold
    column :threshold_type
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
      row :reward_key
      row :name
      row :active
      row :threshold
      row :threshold_type
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
      f.input :reward_key
      f.input :name
      f.input :active
      f.input :threshold
      f.input :threshold_type
      f.input :redemption_instructions
    end
    f.actions
  end
end
