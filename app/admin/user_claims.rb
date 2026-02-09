ActiveAdmin.register UserClaim do
  # Specify parameters which should be permitted for assignment
  permit_params :wiki_id, :user_id, :wiki_user_id, :claimed_username, :claim_code, :status

  # or consider:
  #
  # permit_params do
  #   permitted = [:wiki_id, :user_id, :wiki_user_id, :claimed_username, :claim_code, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :wiki
  filter :user
  filter :wiki_user
  filter :claimed_username
  filter :claim_code
  filter :status
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :wiki
    column :user
    column :wiki_user
    column :claimed_username
    column :claim_code
    column :status
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :wiki
      row :user
      row :wiki_user
      row :claimed_username
      row :claim_code
      row :status
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :wiki
      f.input :user
      f.input :wiki_user
      f.input :claimed_username
      f.input :claim_code
      f.input :status
    end
    f.actions
  end
end
