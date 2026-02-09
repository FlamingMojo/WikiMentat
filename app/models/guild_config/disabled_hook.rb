class GuildConfig
  class DisabledHook < ApplicationRecord
    self.table_name = 'disabled_hooks'

    def self.ransackable_attributes(auth_object = nil)
      %w[created_at guild_config_id hook_name id updated_at]
    end

    def self.ransackable_associations(auth_object = nil)
      ['guild_config']
    end

    belongs_to :guild_config

    validates(
      :hook_name,
      presence: true,
      inclusion: Webhook.hook_types.keys.map(&:to_s),
      uniqueness: { scope: :guild_config_id },
    )
  end
end
