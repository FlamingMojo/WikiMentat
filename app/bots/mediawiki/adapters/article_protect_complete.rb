module Mediawiki::Adapters
  class ArticleProtectComplete < Base
    # {"type"=>"log","ns"=>2,"title"=>"User:Mojo Test/User Claim","pageid"=>14228,"revid"=>40251,"old_revid"=>0,
    #  "rcid"=>45662,"user"=>"FlamingMojo","userid"=>2,"oldlen"=>0,"newlen"=>0,"timestamp"=>"2026-02-06T21:32:42Z",
    #  "comment"=>"Testing protect hooks","logid"=>29674,"logtype"=>"protect","logaction"=>"protect",
    #  "logparams"=>{"description"=>"‎[edit=sysop] (indefinite)‎[move=sysop] (indefinite)",
    #  "details"=>[{"type"=>"edit", "level"=>"sysop", "expiry"=>"infinite"},
    #  {"type"=>"move", "level"=>"sysop", "expiry"=>"infinite"}]},"tags"=>[]}
    private

    def hook
      :ArticleProtectComplete
    end

    def page
      {
        message_key: 'mentat-msg-page-protect',
        title: { prefixedText: changes[:title] },
        url: url_for(changes[:title]),
        reason: changes[:comment],
        protect:,
      }
    end

    def protect
      details = changes.dig(:logparams, :details) || []
      details.map { |p| [ p[:type], p[:level] ] }.to_h
    end
  end
end
