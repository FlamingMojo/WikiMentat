FactoryBot.define do
  factory :wiki do
    sequence(:url) { |n| "https://wiki-#{n}.example" }
    api_path { '/api.php' }
    wiki_prefix { '' }

    trait :with_guild do
      association :guild
    end
  end
end
