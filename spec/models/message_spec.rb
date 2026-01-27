require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:channel) }
    it { is_expected.to have_one(:guild).through(:channel) }
    it { is_expected.to belong_to(:webhook).optional }
  end

  describe 'validations' do
    subject { create(:message) }
    it { is_expected.to validate_presence_of(:discord_uid) }
    it { is_expected.to validate_uniqueness_of(:discord_uid).case_insensitive }
    it { is_expected.to define_enum_for(:message_type).with_values(%i[webhook_update]) }
  end
end
