# frozen_string_literal: true

# Invoked from automated submit actions (non command)
# Updates mission status to submitted
# Updates mission embed with new status
# Posts submit embed with mission details plus submission details, and buttons
module Discord::Commands::Missions
  class Submit
    include Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions'

    def content
    end
  end
end
