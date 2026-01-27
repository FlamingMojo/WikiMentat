FactoryBot.define do
  factory :member do
    association :guild
    association :user

    nickname { 'Member Nickname' }
  end
end
