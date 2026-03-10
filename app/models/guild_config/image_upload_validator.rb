class GuildConfig
  class ImageUploadValidator < ActiveModel::Validator
    def validate(record)
      return unless record.enable_image_upload
      return if record.wiki_bot

      record.errors.add(
        :enable_image_upload,
        'Uploading images from discord requires a Wiki Bot to be configured.'
      )
    end
  end
end
