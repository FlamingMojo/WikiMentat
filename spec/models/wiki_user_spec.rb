require 'rails_helper'

RSpec.describe WikiUser, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:wiki) }
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to have_many(:webhooks) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:username) }
  end
end
