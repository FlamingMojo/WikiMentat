ActiveAdmin.register MemberReward do
  # Specify parameters which should be permitted for assignment
  permit_params :status, :issue_type, :member_id, :reward_id, :issuer_id, :discord_uid, :comment, :issued_at

  # or consider:
  #
  # permit_params do
  #   permitted = [:status, :issue_type, :member_id, :reward_id, :issuer_id, :discord_uid, :comment, :issued_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :status
  filter :issue_type
  filter :member
  filter :reward
  filter :issuer
  filter :discord_uid
  filter :comment
  filter :issued_at
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :status
    column :issue_type
    column :member
    column :reward
    column :issuer
    column :discord_uid
    column :comment
    column :issued_at
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :status
      row :issue_type
      row :member
      row :reward
      row :issuer
      row :discord_uid
      row :comment
      row :issued_at
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :status
      f.input :issue_type
      f.input :member
      f.input :reward
      f.input :issuer
      f.input :discord_uid
      f.input :comment
      f.input :issued_at
    end
    f.actions
  end
end
