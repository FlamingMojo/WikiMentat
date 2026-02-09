class User < ApplicationRecord
  include Omniauthable
  include DiscordEventable

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at discord_uid display_name id id_value mentat_role updated_at username]
  end

  enum :mentat_role, %i[standard admin superadmin], default: :standard

  has_many :members, dependent: :destroy
  has_many :guilds, through: :members
  has_many :roles, through: :members
  has_many :user_claims, dependent: :destroy
  has_many :wiki_users, dependent: :nullify

  validates :discord_uid, presence: true, uniqueness: { case_sensitive: false }

  def roles_for(guild)
    return unless guilds.include?(guild)

    members.find_by(guild:).roles
  end
end
