module Discord::Commands::User
  class Left
    include ::Discord::Util

    def content
      Discord.delete_message(channel: event.message.channel.id, message: event.message.id)

      compare.left!

      FrontBackCompare.new.post_message

      'Confirmed the LEFT was FRONT.'
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



