class WikiBot < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at guild_id id updated_at username wiki_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[guild wiki]
  end

  attr_accessor :bot_password, :bot_password_confirm

  before_validation :verify_password_change, if: :password_changed?

  encrypts :password

  belongs_to :wiki
  belongs_to :guild, optional: true

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true

  delegate(*%i[
    upload_image query handle_command get_page email_user raw_action create_page delete_page protect_page
    block_user unblock_user
    ], to: :client
  )

  def client
    @client ||= Mediawiki::Client.new(url: wiki.api_url, username: username, password: password)
  end

  def password_changed?
    return if @bot_password.blank? || @bot_password_confirm.blank?

    true
  end

  def verify_password_change
    if @bot_password == @bot_password_confirm
      self.password = @bot_password
    else
      errors.add(:password, :not_match)
    end
  end
end
