module Discord::Commands::User
  class Link
    include ::Discord::Util
    include Translatable

    with_locale_context 'discord.commands.user.link_modal'

    def response_params
      { title: t('title'), custom_id: "verify_board:claim:#{wiki_id}" }
    end

    def response_method
      :show_modal
    end

    def response_block
      lambda do |modal|
        modal.row do |row|
          row.text_input(
            style: :short,
            custom_id: 'wiki_username',
            label: t('wiki_username'),
            required: true
          )
        end
      end
    end

    def wiki_id
      custom_id.split(':').last
    end
  end
end
