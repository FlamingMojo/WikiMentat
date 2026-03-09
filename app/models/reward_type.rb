# frozen_string_literal: true

class RewardType < ActiveRecord::Base
  def self.ransackable_attributes(auth_object = nil)
    %w[active created_at guild_config_id id name redemption_instructions reward_key threshold threshold_type updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[guild_config rewards]
  end

  enum :reward_key, %i[atreides_battle_rifle]
  enum :threshold_type, %i[mission_count]

  scope :active, -> { where(active: true) }

  belongs_to :guild_config, inverse_of: :reward_types
  has_many :rewards, inverse_of: :reward_type, dependent: :nullify

  def in_stock?
    rewards.unclaimed.any?
  end

  def next_reward
    rewards.unclaimed.first
  end
end
