# frozen_string_literal: true

# Invoked from selecting mission type from Init
# Returns a new modal to create mission
module Discord::Commands::Missions
  class GrantWiki < Grant
    private

    def title
      @title ||= "Mission Credit for [[#{username}]])"
    end

    def assignee
      @assignee ||= guild.find_member_by_discord_uid("wiki_user_#{username.gsub(/\W/, "")}-#{wiki.name}")
    end

    def username
      event.options['target_user'].to_s
    end
  end
end
