module Discord::Commands::User
  class Skip
    include ::Discord::Util

    def content
      Discord.delete_message(channel: event.message.channel.id, message: event.message.id)
      mission.medium!
      FrontBackCompare.new.post_message

      'Skipped'
    rescue
      'An error occurred. Please try /front_or_back to reset'
    end

    def mission
      Mission.find(custom_id.split(':').last)
    end
  end
end

