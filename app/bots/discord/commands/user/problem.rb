module Discord::Commands::User
  class Problem
    include ::Discord::Util

    def content
      Discord.delete_message(channel: event.message.channel.id, message: event.message.id)

      Discord.send_message(
        channel: 1518636099252256890,
        content: "Found a problem with images from Mission [#{mission.id}](https://mentat.wiki/admin/missions/#{mission.id}) Files: #{compare.image_pages}"
      )

      mission.high!
      FrontBackCompare.new.post_message

      'Raised Problem.'
    rescue StandardError => _e
      @error = true
      'An error occurred. Please try the button below or `/front_or_back` to reset'
    end

    def response_block
      return ->(_builder, _view) { } unless @error

      lambda do |_builder, view|
        view.row do |row|
          row.button(label: 'Reset', custom_id: 'front_or_back', style: :primary)
        end
      end
    end

    def compare
      @compare ||= FrontBackCompare.new(mission)
    end

    def mission
      Mission.find(custom_id.split(':').last)
    end
  end
end

