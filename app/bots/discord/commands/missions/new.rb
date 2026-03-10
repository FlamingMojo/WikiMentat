# frozen_string_literal: true

# Invoked from selecting mission type from Init
# Returns a new modal to create mission
module Discord::Commands::Missions
  class New
    include ::Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.new'

    def response_params
      { title: t('title', type: t(type)), custom_id: "mission:create:#{type}" }
    end

    def response_method
      :show_modal
    end

    def response_block
      lambda do |modal|
        fields.each do |field|
          modal.row do |row|
            row.text_input(
              **{
                style: :short,
                custom_id: field,
                label: t("label.#{field}"),
                placeholder: t("placeholder.#{field}"),
                required: false,
              }.merge(field_settings.fetch(field, {}))
            )
          end
        end
      end
    end

    def fields
      {
        image_upload: %i[title description wiki_page map_link rule],
      }.fetch(type.to_sym, %i[title description wiki_page map_link])
    end

    def field_settings
      {
        title: { required: true },
        description: { required: true, style: :paragraph, value: t("value.description.#{type}") },
        wiki_page: { placeholder: t('placeholder.wiki_page', wiki:) },
        map_link: { placeholder: t('placeholder.map_link', wiki:) },
      }.merge(type_settings.fetch(type.to_sym, {}))
    end

    def type_settings
      {
        page_create: { wiki_page: { required: true, placeholder: t('placeholder.wiki_page', wiki:) } },
        page_update: { wiki_page: { required: true, placeholder: t('placeholder.wiki_page', wiki:) } },
        page_translate: {
          wiki_page: { required: true, placeholder: t('placeholder.wiki_page', wiki:) },
          language: { required: true },
        },
      }
    end

    def type
      event.values.first
    end

    def wiki
      @wiki ||= guild.primary_config.wiki.url
    end
  end
end
