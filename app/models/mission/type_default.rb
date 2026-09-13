class Mission
  class TypeDefault < ApplicationRecord
    def self.ransackable_attributes(auth_object = nil)
      %w[guild_config_id id name thumbnail]
    end

    def self.ransackable_associations(auth_object = nil)
      ["guild_config"]
    end

    self.table_name = 'mission_type_defaults'

    THUMBNAILS = {
      page_create: "#{ENV["HOST_URL"]}/page_create.png",
      page_update: "#{ENV["HOST_URL"]}/page_update.png",
      image_upload: "#{ENV["HOST_URL"]}/image_upload.png",
      page_translate: "#{ENV["HOST_URL"]}/page_translate.png",
      manually_granted: "#{ENV["HOST_URL"]}/manually_granted.png",
    }.freeze

    belongs_to :guild_config
    validates :name, inclusion: Mission::TYPES, uniqueness: { scope: :guild_config }, presence: true

    after_create :global_defaults

    def global_defaults
      return unless name
      thumbnail ||= THUMBNAILS[name.to_sym]

      update(thumbnail:)
    end
  end
end

