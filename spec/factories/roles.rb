FactoryBot.define do
  factory :role do
    association :guild

    role_type { :standard }
    name { 'Role' }
    discord_uid { DiscordID.random }
  end
end
