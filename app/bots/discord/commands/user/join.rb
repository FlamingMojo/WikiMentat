# frozen_string_literal: true

module Discord::Commands::User
  class Join
    include ::Discord::Util

    def handle
      # Don't need to do anything. Discord::Util already created the User and Member from the event.
      true
    end
  end
end
