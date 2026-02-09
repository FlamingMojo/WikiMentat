class UserClaim < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[claim_code claimed_username created_at id id_value status updated_at user_id wiki_id wiki_user_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user wiki wiki_user]
  end
  before_validation :generate_claim_code, unless: :claim_code?

  enum :status, %i[pending confirmed], default: :pending

  belongs_to :wiki
  belongs_to :user
  belongs_to :wiki_user, optional: true

  validates :claimed_username, presence: true
  validates :claim_code, presence: true

  def generate_claim_code
    self.claim_code = UserClaim::Token.new(user:, claimed_username:).code
  end

  def complete!(webhook)
    update!(wiki_user: webhook.wiki_user)
    wiki_user.update!(user: user)
    confirmed!

    webhook.wiki.guild_configs.each do |guild_config|
      next unless user.guilds.include?(guild_config.guild)
      content = I18n.t(
        'discord.commands.user.verify.success',
        user: user.discord_uid, wiki_username: wiki_user.username, wiki: wiki.url
      )
      DiscordChannelBroadcast.new(guild_config:, content:).perform
    end
  rescue => error
    DiscordError.handle(error:, user:, service: 'UserClaim#complete!')
  end
end
