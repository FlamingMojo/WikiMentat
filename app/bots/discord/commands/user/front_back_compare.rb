module Discord::Commands::User
  class FrontBackCompare
    attr_reader :mission, :image_pages

    def initialize(mission = nil)
      @mission = mission || next_mission
      @image_pages = get_image_pages
    end

    def post_message
      Discord.send_message(
        channel: 1474846638760530153,
        content: message,
        attachments: attachments,
        components: buttons
      )
    rescue StandardError => e
      mission.high!

      Discord.send_message(
        channel: 1518636099252256890,
        content: "Found a problem with images from Mission [#{mission.id}](https://mentat.wiki/admin/missions/#{mission.id}) - #{e.message}"
      )

      raise e
    end

    def attachments
      image_pages.map do |image_page|
        image_url = get_image_url(image_page)
        name = image_page.gsub('File:', '').gsub('.jpg', '')
        discord_image = Discord::Commands::User::UploadImage::DiscordImage.new(image_url, name)
        discord_image.generate_image_file! unless File.exist?(discord_image.local_filename)

        File.open(discord_image.local_filename)
      end
    end

    def download_images!
      image_pages.map do |image_page|
        image_url = get_image_url(image_page)
        name = image_page.gsub('File:', '').gsub('.jpg', '')
        discord_image = Discord::Commands::User::UploadImage::DiscordImage.new(image_url, name)
        discord_image.generate_image_file!
      end
    rescue
      mission.high!
    end

    def buttons
      ::Discordrb::Components::View.new do |builder|
        builder.row do |row|
          row.button(label: 'Left', custom_id: "left:#{mission.id}", style: :success)
          row.button(label: 'Right', custom_id: "right:#{mission.id}", style: :primary)
          row.button(label: 'Skip', custom_id: "skip:#{mission.id}", style: :secondary)
          row.button(label: 'Problem', custom_id: "problem:#{mission.id}", style: :danger)
        end
      end
    end

    def left!
      # First is FRONT, Second is BACK
      first = image_pages.first
      front = first.gsub('.jpg', '_Front.jpg').gsub('.jpeg', '_Front.jpg')
      second = image_pages.last
      back = second.gsub('_1.jpg', '_Back.jpg').gsub('_1.jpeg', '_Back.jpg')

      move(from: first, to: front)
      move(from: second, to: back)

      mission.update(wiki_page: "https://awakening.wiki/#{front}")
    end

    def right!
      # First is BACK, Second is FRONT
      first = image_pages.first
      back = first.gsub('.jpg', '_Back.jpg').gsub('.jpeg', '_Back.jpg')
      second = image_pages.last
      front = second.gsub('_1.jpg', '_Front.jpg').gsub('_1.jpeg', '_Front.jpg')

      move(from: second, to: front)
      move(from: first, to: back)

      mission.update(wiki_page: "https://awakening.wiki/#{front}")
    end

    private

    def message
      <<~END
        Which image shows the FRONT of the character?
        (Skip if not applicable, raise a Problem if there is an issue)
        File: #{mission.wiki_page.gsub("https://awakening.wiki/", "")}. Mission ID: #{mission.id}
      END
    end

    def get_image_pages
      first = mission.wiki_page.gsub('https://awakening.wiki/', '')
      if first.ends_with?('_1.jpg') || first.ends_with?('_1.jpeg')
        second = first
        first = first.gsub('_1.jpg', '.jpg').gsub('_1.jpeg', '.jpeg')
      else
        second = first.gsub('.jpg', '_1.jpg').gsub('.jpeg', '_1.jpeg')
      end

      # [ File:Some_Image.jpg, File.Some_Image_1.jpg]
      [ first, second ]
    end

    def move(from:, to:)
      WikiBot.first.raw_action(
        :move, from:, to:, noredirect: true, reason: 'Organising Front and Back character images'
      )
    end

    def get_image_url(page_name)
      # File:Some_filename.jpg
      File.write('tmp/image_pages.json', '{}') unless File.exist?('tmp/image_pages.json')
      image_urls = JSON.parse(File.read('tmp/image_pages.json'))
      return image_urls[page_name] if image_urls[page_name]

      response = WikiBot.first.query(titles: page_name, prop: :imageinfo, iiprop: :url)
      url = response.data['pages'].map { |_k, v| v['imageinfo'].map { |vv| vv['url'] } }.flatten.first
      image_urls[page_name] = url
      File.write('tmp/image_pages.json', JSON.pretty_generate(image_urls))

      url
    end

    def next_mission
      Mission.low.completed.image_upload.joins(:image_rule).
        where(image_rule: { name: 'menu' }).
        where.not(wiki_page: nil).
        where.not("wiki_page ILIKE '%front%'").first
    end
  end
end
