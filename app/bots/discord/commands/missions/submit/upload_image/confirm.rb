# frozen_string_literal: true

# Invoked from button on UploadImage
# Updates previous message to remove buttons.
# Returns message to user.
module Discord::Commands::Missions
  class Submit::UploadImage::Confirm
    include Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.submit.upload_image.confirm'

    def content
      return t('not_found') unless mission
      return t('not_you') unless mentat_member == mission.assignee

      mission.submit
      Discord.delete_message(channel: event.message.channel.id, message: event.message.id)

      t('submitted_mission', summary: mission.summary)
    end

    private

    def mission
      @mission ||= Mission.in_progress.find_by(id: custom_id.split(':').last)
    end
  end
end
