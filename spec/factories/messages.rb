FactoryBot.define do
  factory :message do
    association :webhook
    association :channel

    discord_uid { DiscordID.random }
    message_type { :webhook_update }
    content { 'Some message' }
  end
end
