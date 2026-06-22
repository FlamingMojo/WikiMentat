module Discord::Commands::User
  class Right
    include ::Discord::Util

    def content
      Discord.delete_message(channel: event.message.channel.id, message: event.message.id)

      compare.right!

      FrontBackCompare.new.post_message

      'Confirmed the RIGHT was FRONT.'
    end

    def compare
      @compare ||= FrontBackCompare.new(mission)
    end

    def mission
      Mission.find(custom_id.split(':').last)
    end
  end
end

