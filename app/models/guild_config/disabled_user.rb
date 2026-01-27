class GuildConfig
  class DisabledUser < ApplicationRecord
    self.table_name = 'disabled_users'

    def self.ransackable_attributes(auth_object = nil)
      %w[created_at guild_config_id id updated_at wiki_user_id]
    end

    def self.ransackable_associations(auth_object = nil)
      %w[guild_config wiki_user]
    end

    belongs_to :guild_config
    belongs_to :wiki_user

    validates :wiki_user_id, uniqueness: { scope: :guild_config_id }
  end
end
