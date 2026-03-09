# frozen_string_literal: true

class ImageMissionRule < ActiveRecord::Base
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id image_rule_id mission_id updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[image_rule mission]
  end

  belongs_to :mission
  belongs_to :image_rule
end
