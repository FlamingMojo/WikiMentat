class WikiUser < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id username wiki_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user webhooks wiki]
  end

  belongs_to :wiki
  belongs_to :user, optional: true
  has_many :webhooks

  validates :username, presence: true

  def real_user?
    user && !dummy_user?
  end

  def dummy_user?
    user && user.discord_uid.start_with?('wiki_user')
  end

  def as_json(options = nil)
    { wiki: wiki.url, username: }
  end
end
