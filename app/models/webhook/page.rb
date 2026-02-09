class Webhook
  User = Struct.new(:name, :page, :talk, :contribs, :bot, keyword_init: true)
  Title = Struct.new(:mArticleID, :prefixedText, :mRedirect, keyword_init: true)
  Revision = Struct.new(:diff, :size, :minor, keyword_init: true)

  Page = Struct.new(*Webhook::PAGE_ATTRIBUTES, keyword_init: true) do
    def name
      return Title.new(**title.with_indifferent_access).prefixedText if title
      return file_name if file_name

    end

    def old_name
      return unless old_title

      Title.new(**old_title.with_indifferent_access).prefixedText
    end

    def revision_info
      return unless revision

      Revision.new(**revision.with_indifferent_access)
    end

    def minor_change?
      return false unless revision_info

      revision_info.minor
    end

    def message_key
      (dig(:message_key) || 'default').split('-').excluding(%w[mentat msg]).join('_')
    end
  end
end
