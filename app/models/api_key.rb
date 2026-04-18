class APIKey < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[active created_at id key updated_at user_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[api_request_logs user]
  end

  scope :active, -> { where(active: true) }

  belongs_to :user
  has_many :api_request_logs, dependent: :destroy

  validates :key, uniqueness: true
end
