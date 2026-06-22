module Discord::Commands::User
  class Problem
    include ::Discord::Util

    def content
      Discord.delete_message(channel: event.message.channel.id, message: event.message.id)

      Discord.send_message(
        channel: 1518636099252256890,
        content: "Found a problem with images from Mission ##{mission.id}. Files: #{compare.image_pages}"
      )

      mission.high!
      FrontBackCompare.new.post_message

      'Raised Problem.'
    rescue
      'An error occurred. Please try /front_or_back to reset'
    end

    def compare
      @compare ||= FrontBackCompare.new(mission)
    end

    def mission
      Mission.find(custom_id.split(':').last)
    end
  end
end

