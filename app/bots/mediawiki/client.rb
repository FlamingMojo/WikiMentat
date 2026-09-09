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
      talk_page = get_page(page).body
      lines = talk_page.split("\n")
      titles = lines.each_with_index.map { |l, i| [ l, i ] if l.match?(/^== .* ==$/) }.compact.to_h
      topic_index = titles["== #{topic} =="]
      before_topic, after_topic = [], []
      if topic_index.present?
        next_topic_index = titles.invert.keys.select { |line| line > topic_index }.sort.first || lines.length
        before_topic = lines.take(topic_index)
        after_topic = lines.drop(next_topic_index)
        topic_body = lines.take(next_topic_index).drop(topic_index)
      else
        topic_body = [ "== #{topic} ==", '' ]
      end

      timestamp = Time.now.strftime('%R, %d %B %Y (UTC)')
      topic_body << [ message, signature, timestamp ].join(' ')
      topic_body << ''
      content = (before_topic + topic_body + after_topic).join("\n")

      create_page(page, content)
    end

    private

    def signature
      name = username.split('@').first

      "[[User:#{name}|#{name}]] ([[User_talk:#{name}|talk]])"
    end

    def bot
      @bot ||= MediawikiApi::Client.new(url).tap do |client|
        client.log_in(username, password)
      end
    end
  end
end
