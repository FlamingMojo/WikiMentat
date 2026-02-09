FactoryBot.define do
  factory :user do
    mentat_role { :standard }
    username { 'username' }
    display_name { 'Display Name' }
    discord_uid { DiscordID.random }
  end
end
