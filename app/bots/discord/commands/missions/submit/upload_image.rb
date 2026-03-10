# frozen_string_literal: true

# Invoked from upload image where user has active mission (non-command)
# Returns array of buttons for response
module Discord::Commands::Missions
  class Submit::UploadImage
    include ::Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.submit.upload_image'

    attr_reader :member, :uploaded_files, :channel
    private :member, :uploaded_files, :channel

    def initialize(member:, uploaded_files:, channel:)
      @member = member
      @uploaded_files = uploaded_files
      @channel = channel
    end

    def handle
      return unless mission && uploaded_files.any?
      # Store a file URL first. If cancelled it can be removed later
      mission.update(wiki_page: t('link', image_name: uploaded_files.first.filename.gsub(' ', '_'), wiki:))

      Discord.send_message(channel: channel, content:  t('prompt', summary: mission.summary), components: buttons)
      true
    end

    private

    def wiki
      mission.wiki.url
    end

    def mission
      @mission ||= member.current_mission
    end

    def buttons
      ::Discordrb::Components::View.new do |builder|
        builder.row do |row|
          row.button(label: t('confirm_button'), custom_id: "mission:image:confirm:#{mission.id}", style: :success)
          row.button(label: t('cancel_button'), custom_id: "mission:image:cancel:#{mission.id}", style: :danger)
        end
      end
    end
  end
end
