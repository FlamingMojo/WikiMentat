ActiveAdmin.register Board do
  # Specify parameters which should be permitted for assignment
  permit_params :guild_id, :message_id, :wiki_id, :board_type

  # or consider:
  #
  # permit_params do
  #   permitted = [:guild_id, :message_id, :wiki_id, :board_type]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :guild
  filter :message
  filter :board_type
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :guild
    column :message
    column :wiki
    column :board_type
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :guild
      row :message
      row :wiki
      row :board_type
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :guild
      f.input :message
      f.input :wiki
      f.input :board_type
    end
    f.actions
  end
end
