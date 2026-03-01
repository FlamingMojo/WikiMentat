module Mediawiki::Adapters
  class UserGroupsChanged < Base
    # {"type"=>"log","ns"=>2,"title"=>"User:Mojo Test","pageid"=>0,"revid"=>0,"old_revid"=>0,"rcid"=>45665,
    #  "user"=>"FlamingMojo","userid"=>2,"oldlen"=>0,"newlen"=>0,"timestamp"=>"2026-02-06T21:56:30Z",
    #  "comment"=>"Testing group change hooks","logid"=>29677,"logtype"=>"rights","logaction"=>"rights",
    #  "logparams"=>{"oldgroups"=>[], "newgroups"=>["bot"], "oldmetadata"=>[],
    #  "newmetadata"=>[{"group"=>"bot", "expiry"=>"infinity"}]},"tags"=>[]}
    private

    def hook
      :UserGroupsChanged
    end

    def page
      {
        message_key: 'mentat-msg-user-groups-changed',
        reason: changes[:comment],
        added: changes.dig(:logparams, :newgroups),
        removed: changes.dig(:logparams, :oldgroups),
        performer:,
      }
    end

    def user
      {
        name: username,
        page: url_for("User:#{username}"),
        talk: url_for("User_talk:#{username}"),
        contribs: url_for("Special:Contributions/#{username}"),
      }
    end

    def performer
      {
        name: changes[:user],
        page: url_for("User:#{changes[:user]}"),
        talk: url_for("User_talk:#{changes[:user]}"),
        contribs: url_for("Special:Contributions/#{changes[:user]}"),
        bot: changes.key?(:bot),
      }
    end

    def username
      changes[:title].gsub('User:', '')
    end
  end
end
