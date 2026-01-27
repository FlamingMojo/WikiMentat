class Message < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[channel_id content created_at discord_uid id message_type updated_at webhook_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[channel guild webhook]
  end


  enum :message_type, %i[webhook_update], default: :webhook_update

  belongs_to :webhook, optional: true
  belongs_to :channel
  has_one :guild, through: :channel

  validates :discord_uid, presence: true, uniqueness: { case_sensitive: false }
end
