class Board < ApplicationRecord
  extend Forwardable
  enum :board_type, %i[verify_board], default: :verify_board

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id guild_id message_id board_type updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[guild message]
  end

  def name
    "#{board_type.titleize} - ##{channel.name}"
  end

  belongs_to :guild
  belongs_to :message
  belongs_to :wiki, optional: true
  has_one :channel, through: :message

  def_delegators :message, :discord_uid
end
