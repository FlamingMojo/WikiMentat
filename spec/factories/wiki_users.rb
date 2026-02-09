FactoryBot.define do
  factory :wiki_user do
    association :wiki
    association :user

    username { 'wiki_user' }
  end
end
