require 'rails_helper'

RSpec.describe GuildConfig, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:guild) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:settings) }
  end
end
