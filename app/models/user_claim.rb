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
    complete_with(webhook.wiki_user)
  end

  def complete_with(wiki_user)
    update!(wiki_user:)
    migrate_missions if wiki_user.dummy_user?
    wiki_user.update!(user: user)
    confirmed!

    wiki_user.wiki.guild_configs.each do |guild_config|
      next unless user.guilds.include?(guild_config.guild)
      content = I18n.t(
        'discord.commands.user.verify.success',
        user: user.discord_uid, wiki_username: wiki_user.username, wiki: wiki_user.wiki.url
      )
      DiscordChannelBroadcast.new(guild_config:, content:).perform
    end
  rescue => error
    DiscordError.handle(error:, user:, service: 'UserClaim#complete_with')
  end

  def migrate_missions
    # All WikiUsers create a 'dummy' User so they can complete missions without a discord account
    # Any missions completed and rewards earned should move to the new user as they've been claimed
    dummy_user = wiki_user.user
    user.guilds.each do |guild|
      dummy_member = dummy_user.member_of(guild)
      real_member = user.member_of(guild)
      dummy_member.missions.each do |mission|
        mission.update(assignee: real_member)
        mission.sync_post!
      end
      dummy_member.member_rewards.each do |reward|
        reward.update(rewardable: dummy_member, discord_uid: user.discord_uid)
      end
      dummy_member.destroy
    end
    dummy_user.destroy if dummy_user.reload.members.none?
  end
end
