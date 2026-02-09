require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:guild) }
    it { is_expected.to have_and_belong_to_many(:members) }
  end

  describe 'validations' do
    subject { create(:role) }
    it { is_expected.to validate_presence_of(:discord_uid) }
    it { is_expected.to validate_uniqueness_of(:discord_uid).case_insensitive }
    it { is_expected.to define_enum_for(:role_type).with_values(%i[standard moderator admin]) }
    it { is_expected.to validate_presence_of(:name) }
  end
end
