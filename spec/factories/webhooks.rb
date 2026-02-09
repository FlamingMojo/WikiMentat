FactoryBot.define do
  factory :webhook do
    association :wiki

    hook_type { :PageSaveComplete }
    payload { { wiki: 'wiki', hook_type: 'hook', user: 'user', message: 'message' } }

    trait :with_message do
      association :message
    end

    trait :with_user do
      association :wiki_user
    end
  end
end
