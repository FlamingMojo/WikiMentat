require 'rails_helper'

RSpec.describe UserClaim, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:wiki) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:wiki_user).optional }

  end

  describe 'validations' do
    it { is_expected.to define_enum_for(:status).with_values(%i[pending confirmed]) }
    it { is_expected.to validate_presence_of(:claimed_username) }
    it { is_expected.to validate_presence_of(:claim_code) }
  end
end
