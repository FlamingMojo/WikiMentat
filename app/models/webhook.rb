class Webhook < ApplicationRecord
  PAGE_ATTRIBUTES = %i[
    message_key title url summary reason comment revision archived_revisions visibility_changes protect old_title
    old_url expiry expiry_as_unix target added removed performer new_revision file_name width height mime_type rev_count
    s_rev_count original_title original_url revision_url revision_author image_url uploader old_username new_username
  ]

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at hook_type id message_id payload updated_at wiki_id wiki_user_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[message wiki wiki_user]
  end

  enum :hook_type, %i[
    PageContentSaveComplete PageDeleteComplete PageUndeleteComplete ArticleRevisionVisibilitySet ArticleProtectComplete
    PageMoveComplete LocalUserCreated BlockIpComplete UnblockUserComplete UserGroupsChanged UploadComplete
    FileDeleteComplete FileUndeleteComplete AfterImportPage ArticleMergeComplete ApprovedRevsRevisionApproved
    ApprovedRevsRevisionUnapproved ApprovedRevsFileRevisionApproved ApprovedRevsFileRevisionUnapproved
    RenameUserComplete
  ], default: :PageSaveComplete

  belongs_to :wiki
  belongs_to :wiki_user, optional: true
  belongs_to :message, optional: true

  validates :payload, presence: true
  store_accessor :payload, %i[user page], prefix: :payload

  def user(webhook_user = payload_user)
    Webhook::User.new(**webhook_user.with_indifferent_access)
  end

  %i[target performer uploader revision_author].each do |user_type|
    define_method user_type do
      return unless page.send(user_type)

      user(page.send(user_type))
    end
  end

  def page
    Page.new(**payload_page.with_indifferent_access)
  end
end
