class Wiki < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[api_path created_at id updated_at url wiki_prefix]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[guild_configs guilds user_claims webhooks wiki_bots wiki_users]
  end

  after_create :setup_default_users

  has_many :guild_configs, dependent: :destroy
  has_many :guilds, through: :guild_configs
  has_many :webhooks, dependent: :destroy
  has_many :wiki_bots, dependent: :destroy
  has_many :wiki_users, dependent: :destroy
  has_many :user_claims, dependent: :destroy

  validates :url, presence: true, uniqueness: { case_sensitive: false }
  validates :api_path, presence: true
  # Allow any length of prefix, including 0 (empty string), but not nil
  validates :wiki_prefix, length: { minimum: 0, allow_nil: false }

  def name
    URI(url).host
  end

  def setup_default_users
    # By default, MediaWiki has many service users. These are useful for filtering out some webhooks.
    wiki_users.find_or_create_by(username: 'Redirect fixer')
  end
end
