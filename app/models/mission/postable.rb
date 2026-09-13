class Mission
  # Collection of methods to implement the discord embed posts
  module Postable
    def type_default
      name = manually_granted? ? 'manually_granted' : type

      guild_config.type_defaults.find_by(name:)
    end

    def state_default
      guild_config.state_defaults.find_by(name: status)
    end

    def colour
      return 0x000000 unless state_default

      state_default.colour
    end

    def thumbnail
      return unless type_default

      type_default.thumbnail
    end

    def delete_post!
      return unless discord_post_uid

      post.delete && update(discord_post_uid: nil, discord_post_link: nil)
    end

    def sync_post!
      return post.update if discord_post_uid

      post_message = post.create
      update(
        discord_post_uid: post_message.id,
        discord_post_link: t('link', guild_id: guild.discord_uid, message_id: post_message.id, channel_id: post.channel)
      )
    rescue StandardError => e
      if e.message == 'Unknown Message'
        update(discord_post_uid: nil, discord_post_link: nil)
        reload.sync_post!
      end
    end

    def embed
      Embed.generate(self)
    end

    def post
      Post.new(reload)
    end

    def display_attributes
      attributes.merge('wiki_page_md' => wiki_page_md, 'map_link_md' => map_link_md)
    end

    def wiki_page_md
      format_link(wiki_page)
    end

    def map_link_md
      format_link(map_link)
    end

    def format_link(link)
      return unless link
      "[#{link.split("/").last.split("?").first.gsub("_", " ")}](#{link})"
    end

    def instructions
      params = display_attributes.slice(*I18n.interpolation_keys("mission.instructions.#{type}")).symbolize_keys
      t("instructions.#{type}", **params)
    end

    def channel_uid
      discord_post_link.gsub('https://discord.com/channels/', '').split('/')[1]
    end
  end
end
