module Mediawiki::Adapters
  class PageUndeleteComplete < Base
    # {"type"=>"log","ns"=>2,"title"=>"User:Mojo Test/User Claim","pageid"=>14228,"revid"=>0,"old_revid"=>0,
    #  "rcid"=>45661,"user"=>"FlamingMojo","userid"=>2,"oldlen"=>0,"newlen"=>0,"timestamp"=>"2026-02-06T21:24:24Z",
    #  "comment"=>"Undeleted to test Mentat","logid"=>29672,"logtype"=>"delete","logaction"=>"restore",
    #  "logparams"=>{"count"=>{"revisions"=>2, "files"=>0}},"tags"=>[]}
    private

    def hook
      :PageUndeleteComplete
    end

    def page
      {
        message_key: 'mentat-msg-page-undeleted',
        title: { prefixedText: changes[:title] },
        url: url_for(changes[:title]),
        comment: changes[:comment],
      }
    end
  end
end
