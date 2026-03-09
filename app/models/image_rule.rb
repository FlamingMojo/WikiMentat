# frozen_string_literal: true

class ImageRule < ActiveRecord::Base
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at format guild_config_id id max_height max_width min_height min_width name ratio updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[guild_config image_mission_rules missions]
  end

  belongs_to :guild_config
  has_many :image_mission_rules, dependent: :delete_all
  has_many :missions, through: :image_mission_rules

  def matcher(image_info)
    ImageRule::Matcher.new(rule: self, image_info: image_info)
  end
end
