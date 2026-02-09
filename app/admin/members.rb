ActiveAdmin.register Member do
  # Specify parameters which should be permitted for assignment
  permit_params :guild_id, :user_id, :nickname

  # or consider:
  #
  # permit_params do
  #   permitted = [:guild_id, :user_id, :nickname]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :guild
  filter :user
  filter :nickname

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :guild
    column :user
    column :nickname
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :guild
      row :user
      row :nickname
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :guild
      f.input :user
      f.input :nickname
    end
    f.actions
  end
end
