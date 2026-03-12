# frozen_string_literal: true

class MemberReward < ActiveRecord::Base
  def self.ransackable_attributes(auth_object = nil)
    %w[comment created_at discord_uid id issue_type issued_at issuer_id member_id reward_id status updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[issuer member reward reward_type user]
  end

  enum :status, %i[pending approved]
  enum :issue_type, %i[missions staff manual]

  belongs_to :issuer, class_name: 'Member', optional: true
  belongs_to :reward
  has_one :reward_type, through: :reward
  belongs_to :member
  has_one :user, through: :member

  after_initialize :cache_user, unless: :persisted?

  def award(issuer)
    update(issuer:, status: :approved)
  end

  def unclaim!
    reward.update(member_reward: nil)
    destroy
  end

  def cache_user
    self.discord_uid = member.discord_uid
    self.issued_at = Time.now
  end

  def to_message
    "#{ tag }#{reward_type.name} - `#{pending? ? "PENDING APPROVAL" : reward.key}`"
  end

  def tag
    return '[STAFF]' if staff?
    return '[MANUAL]' if manual?

    ''
  end

  def redacted
    "`#{reward.redacted}`"
  end

  def reward_key
    reward_type.reward_key
  end
end
