FactoryBot.define do
  factory :channel do
    association :guild

    discord_uid { DiscordID.random }
    name { 'discord-channel' }
  end
end
