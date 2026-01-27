class Guild
  class Sync
    attr_reader :guild
    private :guild

    def initialize(guild)
      @guild = guild
    end

    def self.perform(guild)
      new(guild).perform
    end

    def perform
      guild.update(name: discord_server.name)
      sync_channels
      sync_roles
      sync_members
    end

    def sync_channels
      existing_channels.upsert_all(latest_channel_attributes, unique_by: :discord_uid)
      guild.channels.where.not(discord_uid: ids(discord_channels)).destroy_all
    end

    def latest_channel_attributes
      discord_channels.select { |r| existing_channels.map(&:discord_uid).map(&:to_i).include?(r.id) }.map do |channel|
        { discord_uid: channel.id.to_s, name: channel.name }
      end
    end

    def existing_channels
      @existing_channels ||= guild.channels.where(discord_uid: ids(discord_channels))
    end

    def discord_channels
      @discord_channels ||= discord_server.channels
    end

    def sync_roles
      existing_roles.upsert_all(latest_role_attributes, unique_by: :discord_uid)
      guild.roles.where.not(discord_uid: ids(discord_roles)).destroy_all
    end

    def latest_role_attributes
      discord_roles.select { |r| existing_roles.map(&:discord_uid).map(&:to_i).include?(r.id) }.map do |role|
        role_type = :standard
        role_type = :moderator if role.permissions.kick_members
        role_type = :admin if role.permissions.administrator
        { discord_uid: role.id.to_s, name: role.name, role_type: }
      end
    end

    def existing_roles
      @existing_roles ||= guild.roles.where(discord_uid: ids(discord_roles))
    end

    def discord_roles
      @discord_roles ||= discord_server.roles
    end

    def sync_members
      # We don't want to create new Users, just keep the member list updated with users who are in the system
      users.each { |u| guild.members.find_or_create_by(user: u) }
      guild.members.where.not(user: users).destroy_all
      guild.members.find_each do |member|
        discord_member = discord_server.member(member.user.id)
        member.roles = guild.roles.where(discord_uid: ids(discord_member.roles))
        member.save
      end
    end

    def users
      @users ||= User.where(discord_uid: ids(discord_users))
    end

    def discord_users
      @discord_users ||= discord_server.users
    end

    def discord_server
      @discord_server ||= Discord.bot.servers[guild.discord_uid.to_i]
    end

    def ids(collection)
      collection.map(&:id).map(&:to_s)
    end
  end
end
