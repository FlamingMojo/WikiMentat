module Discord::Commands::User
  class Search
    include ::Discord::Util

    def content
      t('user.search.content')
    end

    def response_block
      lambda do |_builder, view|
        view.row do |row|
          row.user_select(
            custom_id: "search:lookup:#{wiki_id}",
            max_values: 1,
            min_values: 1,
            placeholder: t('user.search.placeholder'),
          )
        end
      end
    end

    def wiki_id
      custom_id.split(':').last
    end
  end
end
