require 'rails_helper'

RSpec.describe Wiki, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:guild).optional }
    it { is_expected.to have_many(:webhooks).dependent(:destroy) }
    it { is_expected.to have_many(:wiki_bots).dependent(:destroy) }
    it { is_expected.to have_many(:wiki_users).dependent(:destroy) }
    it { is_expected.to have_many(:user_claims).dependent(:destroy) }
  end

  describe 'validations' do
    subject { create(:wiki) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_uniqueness_of(:url).case_insensitive }
    it { is_expected.to validate_presence_of(:api_path) }
    it { is_expected.to validate_length_of(:wiki_prefix).is_at_least(0).allow_blank }
  end
end
