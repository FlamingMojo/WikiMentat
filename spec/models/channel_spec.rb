require 'rails_helper'

RSpec.describe Channel, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:guild) }
    it { is_expected.to have_many(:messages).dependent(:destroy) }
  end

  describe 'validations' do
    subject { create(:channel) }
    it { is_expected.to validate_presence_of(:discord_uid) }
    it { is_expected.to validate_uniqueness_of(:discord_uid).case_insensitive }
    it { is_expected.to validate_presence_of(:name) }
  end
end
