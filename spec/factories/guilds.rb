FactoryBot.define do
  factory :guild do
    discord_uid { DiscordID.random }
    name { 'DiscordGuild' }
  end
end
