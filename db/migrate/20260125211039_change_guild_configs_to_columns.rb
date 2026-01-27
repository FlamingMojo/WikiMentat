class ChangeGuildConfigsToColumns < ActiveRecord::Migration[8.1]
  def change
    remove_column :guild_configs, :settings, :jsonb

    change_table :guild_configs do |t|
      t.string  :wiki_prefix, default: nil
      t.boolean :send_discord_messages, default: true
      t.boolean :bot_changes, default: false
      t.boolean :minor_changes, default: true
      t.boolean :null_changes, default: false
      t.boolean :suppress_previews, default: true
      t.integer :max_characters, default: 1000
      t.integer :max_username_characters, default: 25
      t.boolean :prepend_timestamp, default: false
      t.boolean :use_emojis, default: false
    end

    create_table :disabled_hooks do |t|
      t.belongs_to :guild_config
      t.string :hook_name, null: false
      t.timestamps
    end

    create_table :disabled_users do |t|
      t.belongs_to :guild_config, null: false, index: true
      t.belongs_to :wiki_user, null: false, index: true
      t.timestamps
    end

    create_table :configured_channels do |t|
      t.belongs_to :guild_config, null: false, index: true
      t.belongs_to :channel, null: false, index: true
      t.integer :channel_purpose, null: false, default: 0
      t.timestamps
    end

    create_table :hook_emojis do |t|
      t.belongs_to :guild_config
      t.string :name
      t.string :discord_uid
      t.string :hook_name, null: false
      t.timestamps
    end
  end
end
