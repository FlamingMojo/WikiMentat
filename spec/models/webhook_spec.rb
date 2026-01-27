require 'rails_helper'

RSpec.describe Webhook, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:wiki) }
    it { is_expected.to belong_to(:wiki_user).optional }
    it { is_expected.to belong_to(:message).optional }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:payload) }
    it { is_expected.to define_enum_for(:hook_type).with_values(%i[
      PageSaveComplete PageDeleteComplete PageUndeleteComplete ArticleRevisionVisibilitySet ArticleProtectComplete
      PageMoveComplete LocalUserCreated BlockIpComplete UnblockUserComplete UserGroupsChanged UploadComplete
      FileDeleteComplete FileUndeleteComplete AfterImportPage ArticleMergeComplete ApprovedRevsRevisionApproved
      ApprovedRevsRevisionUnapproved ApprovedRevsFileRevisionApproved ApprovedRevsFileRevisionUnapproved
      RenameUserComplete
    ]) }
  end
end
