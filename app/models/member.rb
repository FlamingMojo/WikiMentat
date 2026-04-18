class Member < ApplicationRecord
  extend Forwardable

  def self.ransackable_attributes(auth_object = nil)
    %w[guild_id id nickname user_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[guild roles user]
  end

  belongs_to :guild
  belongs_to :user
  has_and_belongs_to_many :roles
  has_many :missions, foreign_key: 'assignee_id'
  has_many :issued_missions, foreign_key: 'issuer_id', class_name: 'Mission'
  has_one :current_mission, -> { accepted }, class_name: 'Mission', foreign_key: 'assignee_id'
  has_many :member_rewards, dependent: :nullify

  # Only to make User.accepted_missions work. A member should only have ONE current mission
  has_many :accepted_missions, -> { accepted }, class_name: 'Mission', foreign_key: 'assignee_id'

  validates :user_id, uniqueness: { scope: :guild_id }
  def_delegators :user, :discord_uid, :username

  def name
    "[#{guild.initials}] #{user.username}"
  end

  def manage_missions?
    moderator? || admin?
  end

  def moderator?
    roles.moderator.any?
  end

  def admin?
    roles.admin.any?
  end

  def claimed_rewards
    member_rewards.approved.map(&:reward_key)
  end
end
