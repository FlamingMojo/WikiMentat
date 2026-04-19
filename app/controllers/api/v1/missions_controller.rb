module API::V1
  class MissionsController < APIController
    def create
      @mission = Mission.new(mission_params)

      if guild_config.enable_missions && guild && member && member.manage_missions?
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

    private

    def mission
      @mission ||= Mission.find_by(id: params[:id])
    end

    def mission_params
      params.expect(:guild_config_id, :type, :title, :description, :wiki_page, :map_link, :rule)
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

    def guild
      @guild ||= guild_config.guild
    end

    def guild_config
      # Don't do @mission.guild_config as @mission could be unpersisted
      @guild_config ||= GuildConfig.find_by(id: @mission.guild_config_id)
    end
  end
end
