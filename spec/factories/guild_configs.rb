FactoryBot.define do
  factory :guild_configs do
    association :guild

    settings { GuildConfig::DEFAULT_SETTINGS }
  end
end
