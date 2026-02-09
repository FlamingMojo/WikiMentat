ActiveAdmin.register Channel do
  # Specify parameters which should be permitted for assignment
  permit_params :guild_id, :discord_uid, :name

  # or consider:
  #
  # permit_params do
  #   permitted = [:guild_id, :discord_uid, :name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :guild
  filter :discord_uid
  filter :name
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :guild
    column :discord_uid
    column :name
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :guild
      row :discord_uid
      row :name
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :guild
      f.input :discord_uid
      f.input :name
    end
    f.actions
  end
end
