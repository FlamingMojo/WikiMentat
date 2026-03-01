module Mediawiki::Adapters
  class PageDeleteComplete < Base
    # {"type"=>"log","ns"=>2,"title"=>"User:Mojo Test/User Claim","pageid"=>14228,"revid"=>0,"old_revid"=>0,
    #  "rcid"=>45660,"user"=>"FlamingMojo","userid"=>2,"oldlen"=>0,"newlen"=>0,"timestamp"=>"2026-02-06T21:17:45Z",
    #  "comment"=>"content was: \"Verifying my discord user trying again!\", and the only...","logid"=>29671,
    #  "logtype"=>"delete","logaction"=>"delete","logparams"=>{},"tags"=>[]}
    private

    def hook
      :PageDeleteComplete
    end

    def page
      {
        message_key: 'mentat-msg-page-deleted',
        title: { prefixedText: changes[:title] },
        url: url_for(changes[:title]),
        reason: changes[:comment],
        archived_revisions: -1, # Not found in the recent changes payload
      }
    end
  end
end
