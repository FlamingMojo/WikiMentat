module Mediawiki::Adapters
  class LocalUserCreated < Base
    # {"type"=>"log","ns"=>2,"title"=>"User:JohnDune","pageid"=>0,"revid"=>0,"old_revid"=>0,"rcid"=>45646,
    #  "user"=>"JohnDune","userid"=>3390,"oldlen"=>0,"newlen"=>0,"timestamp"=>"2026-02-06T17:02:06Z",
    #  "comment"=>"","logid"=>29670,"logtype"=>"newusers","logaction"=>"create","logparams"=>{"userid"=>3390},
    #  "tags"=>[]}
    private

    def hook
      :LocalUserCreated
    end

    def page
      { message_key: 'mentat-msg-user-registered' }
    end
  end
end
