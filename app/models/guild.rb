class Guild < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at discord_uid id name updated_at]
  end

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
  end
end
