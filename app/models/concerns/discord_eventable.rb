module DiscordEventable
  extend ActiveSupport::Concern

  class_methods do
    def from_discord_event(event)
      find_by_discord_event(event) || create_from_discord_event(event)
    end

    def find_by_discord_event(event)
      find_by(discord_uid: event.user.id.to_s).tap do |user|
        # If the user is found, make sure their role is up-to-date
        user.sync_roles(event) if user
      end
    end

    def create_from_discord_event(event)
      create(
        discord_uid: event.user.id.to_s,
        roles: roles_from(event),
        username: event.user.username,
      )
    end

    def roles_from(event)
      Role.where(discord_id: event.user.roles.map(&:id))
    end
  end

  def sync_roles(event)
    # Update all user roles, but preserve any admin role
    update(roles: self.class.roles_from(event))
  end
end
