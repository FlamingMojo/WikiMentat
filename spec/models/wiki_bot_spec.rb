require 'rails_helper'

RSpec.describe WikiBot, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:wiki) }
    it { is_expected.to belong_to(:guild).optional }
  end

  describe 'validations' do
    subject { create(:wiki_bot) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username) }
  end
end
