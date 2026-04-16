ActiveAdmin.register APIRequestLog do
  # Specify parameters which should be permitted for assignment
  permit_params :api_key_id, :endpoint, :payload, :request_method, :response_code, :response_body

  # or consider:
  #
  # permit_params do
  #   permitted = [:api_key_id, :endpoint, :payload, :request_method, :response_code, :response_body]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :api_key
  filter :endpoint
  filter :payload
  filter :request_method
  filter :response_code
  filter :response_body
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :api_key
    column :endpoint
    column :payload
    column :request_method
    column :response_code
    column :response_body
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :api_key
      row :endpoint
      row :payload
      row :request_method
      row :response_code
      row :response_body
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :api_key
      f.input :endpoint
      f.input :payload
      f.input :request_method
      f.input :response_code
      f.input :response_body
    end
    f.actions
  end
end
