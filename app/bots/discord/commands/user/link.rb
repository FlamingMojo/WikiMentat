module Discord::Commands::User
  class Link
    include ::Discord::Util

    def response_params
      { title: t('user.link_modal.title'), custom_id: "verify_board:claim:#{wiki_id}" }
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
            label: t('user.link_modal.wiki_username'),
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
