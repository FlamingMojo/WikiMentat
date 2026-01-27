class Channel < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at discord_uid guild_id id name updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[guild messages]
  end

  belongs_to :guild
  has_many :messages, dependent: :destroy

  validates :discord_uid, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
end
