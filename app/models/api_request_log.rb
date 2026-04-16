class APIRequestLog < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[api_key_id created_at endpoint id id_value payload request_method response_body response_code updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    ['api_key']
  end
  
  belongs_to :api_key

  scope :success, -> { where(response_code: 200..299) }
end
