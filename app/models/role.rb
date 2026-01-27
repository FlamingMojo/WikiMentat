class Role < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at discord_uid guild_id id name role_type updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[guild members]
  end

  enum :role_type, %i[standard moderator admin], default: :standard

  belongs_to :guild
  has_and_belongs_to_many :members

  validates :discord_uid, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
end
