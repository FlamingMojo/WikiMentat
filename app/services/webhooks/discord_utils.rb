module Webhooks
  module DiscordUtils
    # noinspection ALL
    URL_SUBSTITUTIONS = { ' ' => '%20', '(' => '%28', ')' => '%29' }.freeze

    def t(key, *args, **kwargs)
      I18n.t("discord_webhooks.#{key}", *args, **kwargs)
    end

    def key_params
      # Metaprogramming wizardry - find all the keys the I18n record is expecting, then
      # invoke the method (from this module) to get the corresponding value
      I18n.interpolation_keys("discord_webhooks.#{message_key}").map do |key|
        [key.to_sym, sanitize(send(key))]
      end.to_h
    end

    delegate *Webhook::PAGE_ATTRIBUTES.excluding(%i[revision url message_key]), to: :page
    delegate *%i[hook_type target performer uploader revision_author], to: :webhook
    delegate *%i[suppress_previews? max_username_characters max_characters wiki_prefix use_emojis?], to: :guild_config

    def guild
      @guild ||= guild_config.guild
    end

    def wiki_user
      @user ||= wiki.wiki_users.find_by(username: webhook.username)
    end

    def page
      @page ||= webhook.page
    end

    def revision
      @revision ||= page.revision_info
    end

    def disabled?
      guild_config.disabled?(webhook)
    end

    def message_key
      page.message_key
    end

    def user_links(user = webhook.user)
      return '' unless user
      name = markdown_link(text: user.name.truncate(max_username_characters), url: user.page)
      talk = markdown_link(text: t('talk'), url: user.talk)
      contribs = markdown_link(text: t('contribs'), url: user.contribs)

      t('user_links', name:, talk:, contribs:)
    end

    %i[target performer uploader revision_author].each do |user_type|
      define_method "#{user_type}_links" do
        user(user_type)
      end
    end

    # Sanitize text input to prevent abuse of Discord's @here and @everyone pings
    def sanitize(text)
      text.gsub(/(`|@)/, '')
    end

    def new_version
      return '' unless page.new_version

      t('file_upload_new')
    end

    def page_link
      markdown_link(text: page.name, url: page.url)
    end

    def old_page_link
      return unless old_title && old_url

      markdown_link(text: old_title, url: old_url)
    end

    def original_page_link
      return unless original_title && original_url

      markdown_link(text: original_title, url: original_url)
    end

    def new_user_link
      return unless new_username

      markdown_link(text: new_username, url: page.url)
    end

    def protections
      return unless protect

      protect.map { |k,v| "#{k}: #{v}" }.join("\n")
    end

    def emoji
      guild_config.emoji_for(webhook)
    end

    def file_size
      ByteSize.new(size)
    end

    def revision_text
      return unless revision

      diff = markdown_link(text: t('diff'), url: revision.diff)
      minor = revision.minor ? t('minor') : ''
      size = t('size', size: revision.size)

      t('revision_links', diff:, minor:, size:)
    end

    def markdown_link(text:, url:)
      key = suppress_previews? ? 'markdown_url' : 'markdown_url_preview'
      url = encode_url(url)
      t(key, text:, url:)
    end

    def encode_url(url)
      # Discord is particularly finnicky with certain characters in URLs
      URL_SUBSTITUTIONS.each { |bad, good| url.gsub!(bad, good) }

      url
    end

    def limit(text)
      text.truncate(guild_config.max_characters)
    end
  end
end

