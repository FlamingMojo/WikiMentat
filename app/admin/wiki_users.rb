ActiveAdmin.register WikiUser do
  # Specify parameters which should be permitted for assignment
  permit_params :wiki_id, :user_id, :username

  # or consider:
  #
  # permit_params do
  #   permitted = [:wiki_id, :user_id, :username]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :wiki
  filter :user
  filter :username

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :wiki
    column :user
    column :username
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :wiki
      row :user
      row :username
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :wiki
      f.input :user
      f.input :username
    end
    f.actions
  end
end
