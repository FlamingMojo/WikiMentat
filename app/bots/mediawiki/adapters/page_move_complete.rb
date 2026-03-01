module Mediawiki::Adapters
  class PageMoveComplete < Base
    # {"type"=>"log","ns"=>2,"title"=>"User:Mojo Test/User Claim","pageid"=>14228,"revid"=>40252,"old_revid"=>0,
    #  "rcid"=>45663,"user"=>"FlamingMojo","userid"=>2,"oldlen"=>0,"newlen"=>0,"timestamp"=>"2026-02-06T21:49:25Z",
    #  "comment"=>"Testing page move hooks","redirect"=>"","logid"=>29675,"logtype"=>"move","logaction"=>"move",
    #  "logparams"=>{"target_ns"=>2, "target_title"=>"User:Mojo Test/User Claim 2"}
    private

    def hook
      :PageMoveComplete
    end

    def page
      {
        message_key: 'mentat-msg-page-moved',
        old_title: { prefixedText: changes[:title] },
        old_url: url_for(changes[:title]),
        title: { prefixedText: changes.dig(:logparams, :target_title) },
        url: url_for(changes.dig(:logparams, :target_title)),
        reason: changes[:comment],
      }
    end
  end
end
