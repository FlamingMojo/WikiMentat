# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_16_190413) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "mission_priority", ["low", "medium", "high"]
  create_enum "mission_status", ["active", "accepted", "submitted", "completed"]
  create_enum "mission_type", ["page_create", "page_update", "image_upload", "page_translate"]

  create_table "active_admin_comments", force: :cascade do |t|
    t.bigint "author_id"
    t.string "author_type"
    t.text "body"
    t.datetime "created_at", null: false
    t.string "namespace"
    t.bigint "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "api_keys", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["key"], name: "index_api_keys_on_key", unique: true
    t.index ["user_id"], name: "index_api_keys_on_user_id", unique: true
  end

  create_table "api_request_logs", force: :cascade do |t|
    t.bigint "api_key_id", null: false
    t.datetime "created_at", null: false
    t.string "endpoint"
    t.jsonb "payload"
    t.string "request_method"
    t.jsonb "response_body"
    t.integer "response_code"
    t.datetime "updated_at", null: false
    t.index ["api_key_id"], name: "index_api_request_logs_on_api_key_id"
  end

  create_table "boards", force: :cascade do |t|
    t.integer "board_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.bigint "guild_id"
    t.bigint "message_id"
    t.datetime "updated_at", null: false
    t.bigint "wiki_id"
    t.index ["guild_id"], name: "index_boards_on_guild_id"
    t.index ["message_id"], name: "index_boards_on_message_id"
    t.index ["wiki_id"], name: "index_boards_on_wiki_id"
  end

  create_table "channels", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "discord_uid", null: false
    t.bigint "guild_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["discord_uid"], name: "index_channels_on_discord_uid", unique: true
    t.index ["guild_id"], name: "index_channels_on_guild_id"
  end

  create_table "configured_channels", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.integer "channel_purpose", default: 0, null: false
    t.datetime "created_at", null: false
    t.bigint "guild_config_id", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_configured_channels_on_channel_id"
    t.index ["guild_config_id"], name: "index_configured_channels_on_guild_config_id"
  end

  create_table "disabled_hooks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "guild_config_id"
    t.string "hook_name", null: false
    t.datetime "updated_at", null: false
    t.index ["guild_config_id"], name: "index_disabled_hooks_on_guild_config_id"
  end

  create_table "disabled_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "guild_config_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "wiki_user_id", null: false
    t.index ["guild_config_id"], name: "index_disabled_users_on_guild_config_id"
    t.index ["wiki_user_id"], name: "index_disabled_users_on_wiki_user_id"
  end

  create_table "guild_configs", force: :cascade do |t|
    t.boolean "bot_changes", default: false
    t.datetime "created_at", null: false
    t.boolean "enable_image_upload", default: false, null: false
    t.boolean "enable_missions", default: false, null: false
    t.boolean "enable_rewards", default: false, null: false
    t.bigint "guild_id", null: false
    t.integer "max_characters", default: 1000
    t.integer "max_username_characters", default: 25
    t.boolean "minor_changes", default: true
    t.boolean "null_changes", default: false
    t.boolean "prepend_timestamp", default: false
    t.boolean "send_discord_messages", default: true
    t.boolean "suppress_previews", default: true
    t.datetime "updated_at", null: false
    t.boolean "use_emojis", default: false
    t.bigint "wiki_id"
    t.string "wiki_prefix"
    t.boolean "wiki_user_verification", default: true
    t.index ["guild_id"], name: "index_guild_configs_on_guild_id"
    t.index ["wiki_id"], name: "index_guild_configs_on_wiki_id"
  end

  create_table "guilds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "discord_uid", null: false
    t.string "name"
    t.bigint "primary_config_id"
    t.datetime "updated_at", null: false
    t.index ["discord_uid"], name: "index_guilds_on_discord_uid", unique: true
    t.index ["primary_config_id"], name: "index_guilds_on_primary_config_id"
  end

  create_table "hook_emojis", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "discord_uid"
    t.bigint "guild_config_id"
    t.string "hook_name", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["guild_config_id"], name: "index_hook_emojis_on_guild_config_id"
  end

  create_table "image_mission_rules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "image_rule_id"
    t.bigint "mission_id"
    t.datetime "updated_at", null: false
    t.index ["image_rule_id"], name: "index_image_mission_rules_on_image_rule_id"
    t.index ["mission_id"], name: "index_image_mission_rules_on_mission_id"
  end

  create_table "image_rules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "format"
    t.bigint "guild_config_id", null: false
    t.integer "max_height"
    t.integer "max_width"
    t.integer "min_height"
    t.integer "min_width"
    t.string "name"
    t.float "ratio"
    t.datetime "updated_at", null: false
    t.index ["guild_config_id"], name: "index_image_rules_on_guild_config_id"
  end

  create_table "member_rewards", force: :cascade do |t|
    t.string "comment"
    t.datetime "created_at", null: false
    t.string "discord_uid", null: false
    t.integer "issue_type", default: 0, null: false
    t.datetime "issued_at", null: false
    t.bigint "issuer_id"
    t.bigint "member_id", null: false
    t.bigint "reward_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["issuer_id"], name: "index_member_rewards_on_issuer_id"
    t.index ["member_id"], name: "index_member_rewards_on_member_id"
    t.index ["reward_id"], name: "index_member_rewards_on_reward_id"
  end

  create_table "members", force: :cascade do |t|
    t.bigint "guild_id", null: false
    t.string "nickname"
    t.bigint "user_id", null: false
    t.index ["guild_id"], name: "index_members_on_guild_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "members_roles", id: false, force: :cascade do |t|
    t.bigint "member_id", null: false
    t.bigint "role_id", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.string "content"
    t.datetime "created_at", null: false
    t.string "discord_uid", null: false
    t.integer "message_type", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "webhook_id"
    t.index ["channel_id"], name: "index_messages_on_channel_id"
    t.index ["discord_uid"], name: "index_messages_on_discord_uid", unique: true
    t.index ["webhook_id"], name: "index_messages_on_webhook_id"
  end

  create_table "mission_state_defaults", force: :cascade do |t|
    t.bigint "guild_config_id", null: false
    t.string "name", null: false
    t.string "raw_colour"
    t.index ["guild_config_id"], name: "index_mission_state_defaults_on_guild_config_id"
  end

  create_table "mission_type_defaults", force: :cascade do |t|
    t.bigint "guild_config_id", null: false
    t.string "name", null: false
    t.string "thumbnail"
    t.index ["guild_config_id"], name: "index_mission_type_defaults_on_guild_config_id"
  end

  create_table "missions", force: :cascade do |t|
    t.bigint "assignee_id"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "discord_post_link"
    t.string "discord_post_uid"
    t.bigint "guild_config_id", null: false
    t.bigint "issuer_id", null: false
    t.string "language"
    t.string "map_link"
    t.enum "priority", default: "low", null: false, enum_type: "mission_priority"
    t.enum "status", default: "active", null: false, enum_type: "mission_status"
    t.string "title"
    t.enum "type", default: "page_create", null: false, enum_type: "mission_type"
    t.datetime "updated_at", null: false
    t.string "wiki_page"
    t.index ["assignee_id"], name: "index_missions_on_assignee_id"
    t.index ["guild_config_id"], name: "index_missions_on_guild_config_id"
    t.index ["issuer_id"], name: "index_missions_on_issuer_id"
  end

  create_table "reward_types", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.bigint "guild_config_id", null: false
    t.string "name", null: false
    t.text "redemption_instructions"
    t.integer "reward_key", default: 0, null: false
    t.integer "threshold"
    t.integer "threshold_type", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["guild_config_id"], name: "index_reward_types_on_guild_config_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "key", null: false
    t.bigint "member_reward_id"
    t.bigint "reward_type_id", null: false
    t.datetime "updated_at", null: false
    t.index ["member_reward_id"], name: "index_rewards_on_member_reward_id"
    t.index ["reward_type_id"], name: "index_rewards_on_reward_type_id"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "discord_uid", null: false
    t.bigint "guild_id", null: false
    t.string "name", null: false
    t.integer "role_type", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["discord_uid"], name: "index_roles_on_discord_uid", unique: true
    t.index ["guild_id"], name: "index_roles_on_guild_id"
  end

  create_table "user_claims", force: :cascade do |t|
    t.string "claim_code", null: false
    t.string "claimed_username", null: false
    t.datetime "created_at", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "wiki_id", null: false
    t.bigint "wiki_user_id"
    t.index ["user_id"], name: "index_user_claims_on_user_id"
    t.index ["wiki_id"], name: "index_user_claims_on_wiki_id"
    t.index ["wiki_user_id"], name: "index_user_claims_on_wiki_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "discord_uid", null: false
    t.string "display_name"
    t.integer "mentat_role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["discord_uid"], name: "index_users_on_discord_uid", unique: true
  end

  create_table "webhooks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "hook_type", default: 0, null: false
    t.bigint "message_id"
    t.jsonb "payload", default: {}, null: false
    t.datetime "updated_at", null: false
    t.bigint "wiki_id", null: false
    t.bigint "wiki_user_id"
    t.index ["message_id"], name: "index_webhooks_on_message_id"
    t.index ["wiki_id"], name: "index_webhooks_on_wiki_id"
    t.index ["wiki_user_id"], name: "index_webhooks_on_wiki_user_id"
  end

  create_table "wiki_bots", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "guild_id"
    t.text "password", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.bigint "wiki_id", null: false
    t.index ["guild_id"], name: "index_wiki_bots_on_guild_id"
    t.index ["wiki_id"], name: "index_wiki_bots_on_wiki_id"
  end

  create_table "wiki_users", force: :cascade do |t|
    t.bigint "user_id"
    t.string "username", null: false
    t.bigint "wiki_id", null: false
    t.index ["user_id"], name: "index_wiki_users_on_user_id"
    t.index ["wiki_id"], name: "index_wiki_users_on_wiki_id"
  end

  create_table "wikis", force: :cascade do |t|
    t.string "api_path", default: "/api.php", null: false
    t.datetime "created_at", null: false
    t.string "logo_url"
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.string "wiki_prefix", default: "", null: false
    t.index ["url"], name: "index_wikis_on_url", unique: true
  end

  add_foreign_key "guilds", "guild_configs", column: "primary_config_id"
  add_foreign_key "member_rewards", "members", column: "issuer_id"
  add_foreign_key "missions", "members", column: "assignee_id"
  add_foreign_key "missions", "members", column: "issuer_id"
end
