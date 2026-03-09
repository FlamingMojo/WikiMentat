class Guild < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at discord_uid id name updated_at]
  end

  belongs_to :primary_config, optional: true, class_name: 'GuildConfig'
  has_many :members, dependent: :destroy
  has_many :users, through: :members
  has_many :roles, dependent: :destroy
  has_many :channels, dependent: :destroy
  has_many :messages, through: :channels
  has_many :guild_configs, dependent: :destroy
  has_many :wikis, through: :guild_configs
  has_many :wiki_bots, dependent: :nullify

  validates :discord_uid, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  def sync
    Sync.perform(self)

    reload
  end

  def initials
    name.split(' ').map(&:first).join.upcase
  end

  def find_member_by_discord_uid(discord_uid)
    members.joins(:user).where(discord_uid:)
  end

  def find_member_by_username(username)
    members.joins(:user).where(username:)
  end
end
