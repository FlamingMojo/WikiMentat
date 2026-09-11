# Monkeypatch get_wikitext to allow URLs without the /w/ prefix.
class MediawikiApi::Client
  def get_wikitext(title, *args, **kwargs)
    @conn.get '/index.php', action: 'raw', title: title, **kwargs
  end
end

module Mediawiki
  class Client
    attr_reader :url, :username, :password
    private :url, :username, :password

    def initialize(url:, username:, password:)
      @url = url
      @username = username
      @password = password
    end

    def handle_command(method_name, *args, **kwargs)
      skip_retry = kwargs.delete(:skip_retry) || false
      bot.send(method_name, *args, **kwargs)
    rescue MediawikiApi::ApiError => e
      # The most common error is the 10min session timeout. Just re-log in and try again
      puts "WARNING: API Error. #{e}."
      return if skip_retry
      puts "\nRetrying..."
      bot.log_in(username, password)
      bot.send(method_name, *args, **kwargs)
    end

    def query(*args, **kwargs)
      handle_command(:query, *args, **kwargs)
    end

    def protect_page(*args, **kwargs)
      handle_command(:protect_page, *args, **kwargs)
    end

    def delete_page(*args, **kwargs)
      handle_command(:delete_page, *args, **kwargs)
    end

    def create_page(*args, **kwargs)
      handle_command(:create_page, *args, **kwargs)
    end

    def get_page(*args, **kwargs)
      handle_command(:get_wikitext, *args, **kwargs)
    end

    def raw_action(*args, **kwargs)
      handle_command(:raw_action, *args, **kwargs)
    end

    def upload_image(*args, **kwargs)
      # upload_image(filename, path, comment, ignorewarnings, text = nil)
      handle_command(:upload_image, *args, **kwargs)
    end

    def email_user(username:, subject:, text:)
      raw_action(:emailuser, target: username, subject: subject, text: text, skip_retry: true)
    end

    # WILL NOT WORK UNTIL WE UPGRADE TO 1.43+
    # def notify_user(username:, header:, content:, page: nil, section: :alert, email: false)
    #   raw_action(
    #     :echocreateevent,
    #     user: username,
    #     header: header[0...160], # Header has hard limit of 160 bytes
    #     content: content[0...5000], # Content has hard limit of 5000 bytes
    #     page:, section:, email:
    #   )
    # end

    def block_user(user:, reason:)
      raw_action(:block, user:, reason:, autoblock: true, nocreate: true, noemail: true)
    end

    def unblock_user(user:, reason:)
      raw_action(:unblock, user: , reason:)
    end

    def permissions
      query(meta: :userinfo, uiprop: :rights)
    end

    def reply_to_topic(page:, topic:, message:)
      talk_page = DiscussionPage.new(bot: self, title: page)
      talk_page.reply_to_topic(name: topic, message:)
    end

    private

    def bot
      @bot ||= MediawikiApi::Client.new(url).tap do |client|
        client.log_in(username, password)
      end
    end

    class DiscussionPage
      attr_reader :bot, :title, :content

      def initialize(bot:, title:, content: nil)
        @bot = bot
        @title = title
        @content = content || bot.get_page(title).body
      end

      def reply_to_topic(name:, message:)
        topic = topics.find { |t| t.name == name }
        unless topic.present?
          topic = Topic.new(name: name)
          topics << topic
        end

        topic.add_message(message)

        bot.create_page(title, topics.map(&:to_s).join)
      end

      def topics
        @topics ||= parse_topics
      end

      def parse_topics
        return [] unless topic_titles.any?

        parse_topic_lines
        topic_lines.map do |topic_title, lines|
          Topic.new(name: topic_title.gsub('==', '').strip, lines: lines)
        end
      end

      def topic_lines
        # { '== topic ==' => [line1, line2], '== topic 2 ==' => [line4, line5] }
        @topic_lines ||= topic_titles.keys.map { |title| [ title, [] ] }.to_h
      end

      def parse_topic_lines
        # Uses the line map to fill out the topic lines hash
        lines.each_with_index do |line, i|
          next if topic_titles.values.include?(i)
          topic_lines[topic_line_map[i]] << line
        end
      end

      def topic_line_map
        # Maps every line number to a topic
        # { 0 => '== topic ==', 1=> '== topic 2 ==', ...}
        # Improves performance to O(2N)
        topic_ranges.flat_map do |title, range|
          range.to_a.map { |index| [ index, title ] }
        end.to_h
      end

      def topic_ranges
        # Gets the line number ranges for each topic
        # { '== topic ==' => i...j, '== topic 2 ==' => j...len }
        topic_ranges = topic_titles.dup
        arr = topic_ranges.to_a
        topic_ranges.each_with_index.map do |(key, value), i|
          if i >= arr.length - 1
            topic_ranges[key] = (value..(lines.length))
          else
            next_topic = arr[i + 1].first
            topic_ranges[key] = (value...topic_ranges[next_topic])
          end
        end
        topic_ranges
      end

      def topic_titles
        # Gets every topic title and the line number
        # { '== topic ==' => i, '== topic 2 ==' => j }
        @topic_titles ||= lines.each_with_index.map { |l, i| [ l, i ] if l.match?(/^== .* ==$/) }.compact.to_h
      end

      def lines
        @lines ||= content.split("\n")
      end

      class Topic
        attr_reader :name, :lines

        def initialize(name:, lines: [])
          @name = name
          @lines = lines
        end

        def to_s
          [
            "== #{name} ==",
            '',
            *lines,
            ''
          ].join("\n")
        end

        def add_message(message)
          lines << ''
          lines << "#{message.strip} ~~~~"
          lines << ''
        end
      end
    end
  end
end
