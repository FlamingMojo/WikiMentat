ActiveAdmin.register GuildConfig do
  # TODO: ADD SPECS FOR GUILD CONFIG FILES AND FIX EXISTING SPEC
  # Specify parameters which should be permitted for assignment
  permit_params(
    :guild_id, :wiki_id, :wiki_prefix, :send_discord_messages, :bot_changes, :minor_changes, :null_changes, 
    :suppress_previews, :max_characters, :max_username_characters, :prepend_timestamp, :use_emojis, 
    configured_channels_attributes: [ :id, :channel_id, :channel_purpose, :_destroy ],
    disabled_hooks_attributes: [ :id, :hook_name, :_destroy ],
    disabled_users_attributes: [ :id, :wiki_user_id, :_destroy ],
    hook_emojis_attributes: [ :id, :name, :hook_name ],
  )

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :guild
  filter :wiki
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :guild
    column :wiki
    column :created_at
    column :updated_at
    column :wiki_prefix
    column :send_discord_messages
    column :bot_changes
    column :minor_changes
    column :null_changes
    column :suppress_previews
    column :max_characters
    column :max_username_characters
    column :prepend_timestamp
    column :use_emojis
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :guild
      row :wiki
      row :wiki_prefix
      row :send_discord_messages
      row :bot_changes
      row :minor_changes
      row :null_changes
      row :suppress_previews
      row :max_characters
      row :max_username_characters
      row :prepend_timestamp
      row :use_emojis
      row :created_at
      row :updated_at
      row 'Configured Channels' do
        table_for resource.configured_channels do
          column :channel
          column :channel_purpose
        end
      end
      row 'Disabled Hooks' do
        table_for resource.disabled_hooks do
          column :hook_name
        end
      end
      row 'Disabled Users' do
        table_for resource.disabled_users do
          column :wiki_user
        end
      end
      if resource.use_emojis?
        row 'Hook Emojis' do
          table_for resource.hook_emojis do
            column :hook_name
            column :name
          end
        end
      end
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :guild
      f.input :wiki
      f.input :wiki_prefix
      f.input :send_discord_messages
      f.input :bot_changes
      f.input :minor_changes
      f.input :null_changes
      f.input :suppress_previews
      f.input :max_characters
      f.input :max_username_characters
      f.input :prepend_timestamp
      f.input :use_emojis
      if resource.persisted?
        f.has_many :configured_channels, heading: 'Configured Channels', allow_destroy: true, new_record: true do |cf|
          cf.input :id, as: :hidden
          cf.input :channel_purpose
          cf.input :channel, collection: resource.guild.channels
        end

        f.has_many :disabled_users, heading: 'Disabled Users', allow_destroy: true, new_record: true do |cf|
          cf.input :id, as: :hidden
          cf.input :wiki_user, collection: resource.wiki.wiki_users
        end

        f.has_many :disabled_hooks, heading: 'Disabled Hooks', allow_destroy: true, new_record: true do |cf|
          cf.input :id, as: :hidden
          cf.input :hook_name, collection: Webhook.hook_types.keys
        end

        if resource.use_emojis?
          f.has_many :hook_emojis, heading: 'Hook Emojis' do |cf|
            cf.input :id, as: :hidden
            cf.input :hook_name, collection: Webhook.hook_types.keys
            cf.input(
              :name,
              as: :select,
              collection: GuildConfig::HookEmoji::DEFAULT_HOOK_EMOJIS.map { |e| e[:name] }
            )
          end
        end
      end
    end
    f.actions
  end
end
