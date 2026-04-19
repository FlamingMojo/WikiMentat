# frozen_string_literal: true

# Invoked from Submit embed buttons
# Completes the mission
# Rewards the user
# Deletes mission post
# Updates submit embed to remove buttons and update status
module Discord::Commands::Missions
  class Approve
    include ::Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.approve'

    def content
      return t('not_found') unless mission
      return t('not_submitted') unless mission.submitted?
      return t('not_assigned') unless mission.assignee

      mission.approve
    rescue => error
      DiscordError.handle(error:, user: mentat_user, service: self.class.to_s)
    end

    private

    def mission
      @mission ||= guild_config.missions.find_by(id: custom_id.split(':').last)
    end

    def guild_config
      @guild_config ||= guild.primary_config
    end
  end
end
