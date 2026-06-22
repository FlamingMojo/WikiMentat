module Discord::Commands::User
  class FrontOrBack
    include ::Discord::Util

    def content
      compare.post_message

      'Posted'
    end

    def compare
      @compare ||= FrontBackCompare.new
    end
  end
end


