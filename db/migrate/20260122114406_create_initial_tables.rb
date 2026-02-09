class CreateInitialTables < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :discord_uid, null: false, index: { unique: true }
      t.string :username
      t.string :display_name
      t.integer :mentat_role, null: false, default: 0
      t.timestamps
    end

    create_table :guilds do |t|
      t.string :discord_uid, null: false, index: { unique: true }
      t.string :name
      t.timestamps
    end

    create_table :roles do |t|
      t.belongs_to :guild, index: true, null: false
      t.string :discord_uid, null: false, index: { unique: true }
      t.string :name, null: false
      t.integer :role_type, null: false, default: 0
      t.timestamps
    end

    create_table :members do |t|
      t.belongs_to :guild, index: true, null: false
      t.belongs_to :user, index: true, null: false
      t.string :nickname
    end

    create_join_table :members, :roles

    create_table :channels do |t|
      t.belongs_to :guild, index: true, null: false
      t.string :discord_uid, null: false, index: { unique: true }
      t.string :name, null: false
      t.timestamps
    end

    create_table :messages do |t|
      t.belongs_to :channel, index: true, null: false
      t.belongs_to :webhook
      t.string :discord_uid, null: false, index: { unique: true }
      t.string :content
      t.integer :message_type, null: false, default: 0
      t.timestamps
    end

    create_table :guild_configs do |t|
      t.belongs_to :guild, index: true, null: false
      t.jsonb :settings, default: {}, null: false
      t.timestamps
    end

    create_table :wikis do |t|
      t.belongs_to :guild, index: true
      t.string :url, null: false, index: { unique: true }
      t.string :api_path, null: false, default: '/api.php'
      t.string :wiki_prefix, null: false, default: ''
      t.timestamps
    end

    create_table :wiki_bots do |t|
      t.belongs_to :wiki, index: true, null: false
      t.belongs_to :guild, index: true
      t.string :username, null: false
      t.text :password, null: false
      t.timestamps
    end

    create_table :wiki_users do |t|
      t.belongs_to :wiki, index: true, null: false
      t.belongs_to :user, index: true
      t.string :username, null: false
    end

    create_table :webhooks do |t|
      t.belongs_to :wiki, index: true, null: false
      t.belongs_to :wiki_user, index: true
      t.belongs_to :message
      t.jsonb :payload, default: {}, null: false
      t.integer :hook_type, default: 0, null: false
      t.timestamps
    end

    create_table :user_claims do |t|
      t.belongs_to :wiki, index: true, null: false
      t.belongs_to :user, index: true, null: false
      t.belongs_to :wiki_user
      t.string :claimed_username, null: false
      t.string :claim_code, null: false
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
