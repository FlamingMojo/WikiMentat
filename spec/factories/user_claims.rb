FactoryBot.define do
  factory :user_claim do
    association :user
    association :wiki

    status { :pending }
    claimed_username { 'wiki_username' }
    claim_code { '000000' }
  end
end
