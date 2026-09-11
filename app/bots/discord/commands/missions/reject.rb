# frozen_string_literal: true

# Invoked from Submit embed buttons
# Sets mission back to accepted
# DM's user
# Updates submit embed to remove buttons and update status
module Discord::Commands::Missions
  class Reject
    include ::Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.reject'

    def content
      error_message
    rescue => error
      DiscordError.handle(error:, user: mentat_user, service: self.class.to_s)
      t('../', summary: mission.summary)
    end

    def response_params
      return super if error_message

      { title: t('title'), custom_id: "mission:feedback:#{mission.id}" }
    end

    def response_method
      return super if error_message

      :show_modal
    end

    def response_block
      lambda do |modal|
        modal.label t('labels.feedback') do |label|
          label.text_input(
            style: :paragraph,
            custom_id: 'feedback',
            required: true,
            placeholder: t('placeholders.feedback')
          )
        end
      end
    end

    private

    def error_message
      return t('not_found') unless mission
      return t('not_submitted') unless mission.submitted?
      return t('not_assigned') unless mission.assignee

      nil
    end

    def mission
      @mission ||= Mission.find_by(id: custom_id.split(':').last)
    end
  end
end
