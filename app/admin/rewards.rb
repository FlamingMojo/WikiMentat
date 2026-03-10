ActiveAdmin.register Reward do
  # Specify parameters which should be permitted for assignment
  permit_params :reward_type_id, :member_reward_id, :key

  # or consider:
  #
  # permit_params do
  #   permitted = [:reward_type_id, :member_reward_id, :key]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :reward_type
  filter :member_reward
  filter :key
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :reward_type
    column :member_reward
    column :key
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :reward_type
      row :member_reward
      row :key
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :reward_type
      f.input :member_reward
      f.input :key
    end
    f.actions
  end
end
