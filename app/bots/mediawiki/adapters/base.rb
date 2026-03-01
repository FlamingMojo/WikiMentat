module Mediawiki
  module Adapters
    class Base
      attr_reader :bot, :changes
      private :bot, :changes

      def initialize(bot:, changes:)
        @bot = bot
        @changes = changes.with_indifferent_access
      end

      def adapt
        { wiki: wiki.url, user:, page:, hook:, source: bot.name }
      end

      private

      def hook
        ''
      end

      def page
        {}
      end

      def url_for(page)
        [ wiki.url, wiki.wiki_prefix.presence, page ].compact.join('/').gsub(' ', '_')
      end

      def user
        {
          name: changes[:user],
          page: url_for("User:#{changes[:user]}"),
          talk: url_for("User_talk:#{changes[:user]}"),
          contribs: url_for("Special:Contributions/#{changes[:user]}"),
          bot: changes.key?(:bot),
        }
      end

      def wiki
        @wiki ||= bot.wiki
      end

      def wiki_user
        @wiki_user ||= wiki.wiki_users.find_or_create_by(username: changes[:user])
      end
    end
  end
end
