class CreateMissionsTables < ActiveRecord::Migration[8.1]
  def change
    create_enum :mission_status, %w[active accepted submitted completed]
    create_enum :mission_priority, %w[low medium high]
    create_enum :mission_type, %w[page_create page_update image_upload page_translate]

    change_table :guilds do |t|
      t.belongs_to :primary_config, foreign_key: { to_table: :guild_configs }, index: true
    end

    change_table :guild_configs do |t|
      t.boolean :enable_missions, default: false, null: false
      t.boolean :enable_rewards, default: false, null: false
      t.boolean :enable_image_upload, default: false, null: false
    end

    create_table :mission_type_defaults do |t|
      t.belongs_to :guild_config, index: true, null: false
      t.string :name, null: false
      t.string :thumbnail
    end

    create_table :mission_state_defaults do |t|
      t.belongs_to :guild_config, index: true, null: false
      t.string :name, null: false
      t.string :raw_colour
    end

    create_table :missions do |t|
      t.string :title
      t.text :description
      t.string :wiki_page
      t.string :language
      t.string :map_link
      t.string :discord_post_link
      t.string :discord_post_uid
      t.belongs_to :issuer, foreign_key: { to_table: :members }, index: true, null: false
      t.belongs_to :assignee, foreign_key: { to_table: :members }, index: true
      t.belongs_to :guild_config, index: true, null: false
      t.enum :status, enum_type: :mission_status, default: 'active', null: false
      t.enum :type, enum_type: :mission_type, default: 'page_create', null: false
      t.enum :priority, enum_type: :mission_priority, default: 'low', null: false
      t.datetime :completed_at
      t.timestamps
    end

    create_table :reward_types do |t|
      t.belongs_to :guild_config, null: false
      t.integer :reward_key, null: false, default: 0
      t.string :name, null: false
      t.boolean :active, default: true
      t.integer :threshold
      t.integer :threshold_type, default: 0, null: false
      t.text :redemption_instructions
      t.timestamps
    end

    create_table :rewards do |t|
      t.belongs_to :reward_type, null: false, index: true
      t.belongs_to :member_reward
      t.text :key, null: false
      t.timestamps
    end

    create_table :member_rewards do |t|
      t.integer :status, null: false, default: 0
      t.integer :issue_type, null: false, default: 0
      t.belongs_to :member, null: false, index: true
      t.belongs_to :reward, null: false, index: true
      t.belongs_to :issuer, foreign_key: { to_table: :members }, index: true
      t.string :discord_uid, null: false
      t.string :comment
      t.datetime :issued_at, null: false
      t.timestamps
    end

    create_table :image_rules do |t|
      t.belongs_to :guild_config, null: false
      t.string :name
      t.integer :min_width
      t.integer :min_height
      t.integer :max_width
      t.integer :max_height
      t.float :ratio
      t.string :format
      t.timestamps
    end

    create_table :image_mission_rules do |t|
      t.belongs_to :image_rule
      t.belongs_to :mission
      t.timestamps
    end
  end
end
