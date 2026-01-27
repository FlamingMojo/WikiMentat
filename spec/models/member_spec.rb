require 'rails_helper'

RSpec.describe Member, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:guild) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_and_belong_to_many(:roles) }
  end
end
