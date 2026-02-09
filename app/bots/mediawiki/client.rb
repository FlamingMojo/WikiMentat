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

    private

    def bot
      @bot ||= MediawikiApi::Client.new(url).tap do |client|
        client.log_in(username, password)
      end
    end
  end
end
