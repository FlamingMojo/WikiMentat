FactoryBot.define do
  factory :wiki_bot do
    association :wiki

    sequence(:username) { |n| "wiki_bot_#{n}" }
    password { 'password' }

    trait :with_guild do
      association :guild
    end
  end
end
