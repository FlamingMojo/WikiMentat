# frozen_string_literal: true

module Discord::Commands::Admin
  class Sync
    include ::Discord::Util

    def content
      guild.sync

      'Synced Guild'
    end
  end
end


