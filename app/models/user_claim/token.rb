class UserClaim
  class Token
    attr_reader :user, :claimed_username
    private :user, :claimed_username

    def initialize(user:, claimed_username:)
      @user = user
      @claimed_username = claimed_username
    end

    def code
      totp.at(0)
    end

    def verify(candidate)
      totp.verify(candidate, 0)
    end

    private

    def totp
      @totp ||= ROTP::HOTP.new(secret)
    end

    def secret
      Base32.encode("#{user.discord_uid}-#{ENV['VERIFICATION_TOKEN_SALT']}-#{claimed_username}")
    end
  end
end
