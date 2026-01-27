require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:members).dependent(:destroy) }
    it { is_expected.to have_many(:guilds).through(:members) }
    it { is_expected.to have_many(:roles).through(:members) }
    it { is_expected.to have_many(:user_claims).dependent(:destroy) }
    it { is_expected.to have_many(:wiki_users).dependent(:nullify) }
  end

  describe 'validations' do
    subject { create(:user) }
    it { is_expected.to validate_presence_of(:discord_uid) }
    it { is_expected.to validate_uniqueness_of(:discord_uid).case_insensitive }
    it { is_expected.to define_enum_for(:mentat_role).with_values(%i[standard admin superadmin]) }
  end
end
