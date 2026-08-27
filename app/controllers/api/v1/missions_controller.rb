module API::V1
  class MissionsController < APIController
    def index
      @q = Mission.for_user(@current_user).ransack(params[:q])
      @missions = @q.result(distinct: true)

      handle_response(@missions.to_json, status: 200)
    rescue => error
      handle_response({ error: error.message }, status: 400)
    end

    def create
      @mission = Mission.new(mission_params)

      if guild_config.enable_missions && guild && member && member.manage_missions?
        @mission.issuer = member
        if @mission.save
          @mission.sync_post! && @mission.reload
          handle_response(@mission.as_json, status: 201)
        else
          handle_response({ error: @mission.errors.as_json }, status: 400)
        end
      else
        handle_response({ error: 'The guild does not allow you to create missions.' }, status: 403)
      end
    end

    def update
      if mission && guild_config.enable_missions && guild && member && member.manage_missions?
        if mission.update(mission_params)
          handle_response(mission.as_json, status: 200)
        else
          handle_response({ error: @mission.errors.as_json }, status: 400)
        end
      else
        handle_response({ error: 'Not able to cancel mission' }, status: 400)
      end
    end

    def show
      if mission && guild_config.enable_missions && member
        handle_response(mission.as_json, status: 200)
      else
        handle_response({ error: 'Mission not found' }, status: 404)
      end
    end

    def cancel
      if mission && guild_config.enable_missions && guild && member && member.manage_missions?
        mission.cancel
        handle_response({ message: "Successfully cancelled Mission [#{mission.id}]"}, status: 200)
      else
        handle_response({ error: 'Not able to cancel mission' }, status: 400)
      end
    end

    def abandon
      if mission && guild_config.enable_missions && guild && member && member.manage_missions?
        mission.abandon
        handle_response({ message: "Successfully abandoned Mission [#{mission.id}]"}, status: 200)
      else
        handle_response({ error: 'Not able to cancel mission' }, status: 400)
      end
    end

    def submit
      if mission&.accepted? && guild_config.enable_missions && guild && member && member.manage_missions?
        mission.submit
        handle_response({ message: "Successfully manually submitted Mission [#{mission.id}]"}, status: 200)
      else
        handle_response({ error: 'Not able to cancel mission' }, status: 400)
      end
    end

    def approve
      if mission&.submitted? && guild_config.enable_missions && guild && member && member.manage_missions?
        mission.approve
        handle_response({ message: "Successfully approved Mission [#{mission.id}]"}, status: 200)
      else
        handle_response({ error: 'Not able to cancel mission' }, status: 400)
      end
    end

    def reject
      if mission&.submitted? && guild_config.enable_missions && guild && member && member.manage_missions?
        mission.reject
        handle_response({ message: "Successfully rejected Mission [#{mission.id}]"}, status: 200)
      else
        handle_response({ error: 'Not able to cancel mission' }, status: 400)
      end
    end

    def accept_wiki
      if mission&.active? && guild_config.enable_missions && guild && wiki_member&.current_mission.nil?
        mission.accept(wiki_member)
        handle_response({ message: "Successfully abandoned Mission [#{mission.id}]"}, status: 200)
      else
        handle_response({ message: 'Not able to accept mission' }, status: 200)
      end
    end

    def abandon_wiki
      if mission && guild_config.enable_missions && guild && mission == wiki_member&.current_mission
        mission.abandon
        handle_response({ message: "Successfully abandoned Mission [#{mission.id}]"}, status: 200)
      else
        handle_response({ message: 'Not able to abandon mission' }, status: 200)
      end
    end

    private

    def wiki_member
      return unless wiki_user&.user

      @wiki_member = wiki_user.user.member_of(guild)
    end

    def wiki_user
      @wiki_user ||= wiki.wiki_users.find_by(username: params[:wiki_username])
    end

    def mission
      @mission ||= Mission.find_by(id: params[:id])
    end

    def mission_params
      params.permit(:guild_config_id, :type, :title, :description, :wiki_page, :map_link, :rule)
    end

    def assignee_member
      @assignee_member ||= assignee.member_of(guild)
    end

    def assignee
      @assignee ||= User.find_by(discord_uid: assignee_params[:discord_id])
    end

    def assignee_params
      params.expect(:discord_id)
    end

    def member
      @member ||= @current_user.member_of(guild)
    end

    def wiki
      @wiki ||= guild_config.wiki
    end

    def guild
      @guild ||= guild_config.guild
    end

    def guild_config
      # Don't do @mission.guild_config as @mission could be unpersisted
      @guild_config ||= GuildConfig.find_by(id: @mission.guild_config_id)
    end
  end
end
