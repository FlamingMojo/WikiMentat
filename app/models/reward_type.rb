# frozen_string_literal: true

class RewardType < ActiveRecord::Base
  def self.ransackable_attributes(auth_object = nil)
    %w[active created_at guild_config_id id name redemption_instructions conditions updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[guild_config rewards]
  end

  scope :active, -> { where(active: true) }
  scope :available_for, ->(member) {
    active.joins(guild_config: :guild).
      where.not(id: member.earned_reward_types.pluck(:id)).
      where(guild_config: { guild: member.guild })
  }

  belongs_to :guild_config, inverse_of: :reward_types
  has_many :rewards, inverse_of: :reward_type, dependent: :nullify
  has_many :member_rewards, through: :rewards
  has_many :members, through: :member_rewards

  validate :validate_conditions

  def in_stock?
    rewards.unclaimed.any?
  end

  def next_reward
    rewards.unclaimed.first
  end

  def validate_conditions
    errors.add(:config, conditions.errors.join(',')) unless conditions.valid?
  end

  def check(member, **other_sources)
    return false if config.empty?
    return false if member.earned_reward_types.include?(self)

    conditions.call({ assignee: member }.merge(other_sources))
  end

  def conditions
    @conditions ||= Conditions.new(JSON.parse(config))
  end

  def default_config!
    update(config: {
      variables: [
        { name: 'missions_count', source: 'assignee', method_chain: %w[reload missions completed count] },
        { name: 'seven', source: 'static', value: 7 },
      ],
      operations: [
        { op: 'gte', arg1: 'missions_count', arg2: 'seven' },
      ],
      conjunction: :and,
    }.to_json)
  end
end
