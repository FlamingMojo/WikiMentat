module Omniauthable
  extend ActiveSupport::Concern

  class_methods do
    def login_with_oauth(auth)
      find_by_oauth(auth) || create_from_oauth(auth)
    end

    def find_by_oauth(auth)
      find_by(discord_uid: auth.uid)
    end

    def create_from_oauth(auth)
      create(discord_uid: auth.uid, username: auth.info.name)
    end
  end
end
