class UserClaim < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[claim_code claimed_username created_at id status updated_at user_id wiki_id wiki_user_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user wiki wiki_user]
  end

  enum :status, %i[pending confirmed], default: :pending

  belongs_to :wiki
  belongs_to :user
  belongs_to :wiki_user, optional: true

  validates :claimed_username, presence: true
  validates :claim_code, presence: true
end
