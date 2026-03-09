# frozen_string_literal: true

# Invoked from mission modal from New
# Posts mission embed with buttons.
# Returns confirmation to admin
module Discord::Commands::Missions
  class Create
    include Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.create'

    def content
      return t('errors', errors: mission.errors.full_messages) unless mission.persisted?
      mission.sync_post!

      t('success', id: mission.id, link: mission.discord_post_link)
    end

    def response_method
      :update_message
    end

    private

    def mission
      @mission ||= Mission.create(
        guild_config: guild.primary_config,
        type: type,
        issuer: mentat_member,
        **modal_values.symbolize_keys.delete_if { |_, v| v.nil? || v.empty? }
      )
    end

    def type
      custom_id.split(':').last
    end

    def modal_keys
      %w[title description wiki_page map_link rule]
    end
  end
end
