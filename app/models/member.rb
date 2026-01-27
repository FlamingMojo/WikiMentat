class Member < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[guild_id id nickname user_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[guild roles user]
  end

  belongs_to :guild
  belongs_to :user
  has_and_belongs_to_many :roles

  validates :user_id, uniqueness: { scope: :guild_id }
end
