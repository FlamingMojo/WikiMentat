module Discord::Commands::User
  class FrontOrBack
    include ::Discord::Util

    def content
      compare.post_message

      'Posted'
    rescue StandardError => _e
      @error = true
      'An error occurred. Please try the button below or `/front_or_back` to reset'
    end

    def response_block
      return ->(_builder, _view) { } unless @error

      lambda do |_builder, view|
        view.row do |row|
          row.button(label: 'Reset', custom_id: 'front_or_back', style: :primary)
        end
      end
    end

    def compare
      @compare ||= FrontBackCompare.new
    end
  end
end


