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
  has_many :approved_member_rewards, -> { approved }, class_name: 'MemberReward', foreign_key: 'member_id'
  has_many :rewards, through: :member_rewards
  has_many :earned_rewards, through: :approved_member_rewards, source: :reward
  has_many :reward_types, through: :rewards
  has_many :earned_reward_types, through: :earned_rewards, source: :reward_type

  # Only to make User.accepted_missions work. A member should only have ONE current mission
  has_many :accepted_missions, -> { accepted }, class_name: 'Mission', foreign_key: 'assignee_id'

  validates :user_id, uniqueness: { scope: :guild_id }
  def_delegators :user, :discord_uid, :username, :wiki_user_for

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
    earned_rewards.map(&:name)
  end
end
