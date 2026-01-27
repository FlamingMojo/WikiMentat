class WikiBot < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at guild_id id password updated_at username wiki_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[guild wiki]
  end

  encrypts :password

  belongs_to :wiki
  belongs_to :guild, optional: true

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true

  delegate(
    *%i[upload_image query handle_command get_page email_user raw_action create_page delete_page protect_page],
    to: :client
  )

  def client
    @client ||= Mediawiki::Client.new(url: wiki.url, username: username, password: password)
  end
end
