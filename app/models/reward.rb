# frozen_string_literal: true

class Reward < ActiveRecord::Base
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id key member_reward_id reward_type_id updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[member member_reward reward_type]
  end

  encrypts :key
  belongs_to :reward_type
  belongs_to :member_reward, optional: true
  has_one :member, through: :member_reward, source: :member

  scope :unclaimed, -> { where(member_reward_id: nil) }
  scope :claimed, -> { where.not(member_reward_id: nil) }

  def issue_to(member, **kwargs)
    transaction do
      member_reward = MemberReward.create!(reward: self, member:, **kwargs)
      update(member_reward:)
    end
    member_reward
  end
end
