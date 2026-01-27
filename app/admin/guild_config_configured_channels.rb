ActiveAdmin.register GuildConfig::ConfiguredChannel do
  # Specify parameters which should be permitted for assignment
  permit_params :guild_config_id, :channel_id, :channel_purpose

  # or consider:
  #
  # permit_params do
  #   permitted = [:guild_config_id, :channel_id, :channel_purpose]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :guild_config
  filter :channel
  filter :channel_purpose
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :guild_config
    column :channel
    column :channel_purpose
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :guild_config
      row :channel
      row :channel_purpose
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :guild_config
      f.input :channel
      f.input :channel_purpose
    end
    f.actions
  end
end
