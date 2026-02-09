require 'rails_helper'

RSpec.describe Guild, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:members).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:members) }
    it { is_expected.to have_many(:roles).dependent(:destroy) }
    it { is_expected.to have_many(:channels).dependent(:destroy) }
    it { is_expected.to have_many(:messages).through(:channels) }
    it { is_expected.to have_one(:guild_config).dependent(:destroy) }
    it { is_expected.to have_many(:wikis).dependent(:nullify) }
    it { is_expected.to have_many(:wiki_bots).dependent(:nullify) }
  end

  describe 'validations' do
    subject { create(:guild) }
    it { is_expected.to validate_presence_of(:discord_uid) }
    it { is_expected.to validate_uniqueness_of(:discord_uid).case_insensitive }
    it { is_expected.to validate_presence_of(:name) }
  end
end
