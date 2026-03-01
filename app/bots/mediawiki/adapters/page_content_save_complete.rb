module Mediawiki::Adapters
  class PageContentSaveComplete < Base
    # CREATED -{"type"=>"new","ns"=>2,"title"=>"User:FlamingMojo/Test (with brackets)","pageid"=>14223,"revid"=>40203,
    #     "old_revid"=>0,"rcid"=>45601,"user"=>"FlamingMojo","userid"=>2,"new"=>"","oldlen"=>0,"newlen"=>20,
    #     "timestamp"=>"2026-02-05T21:21:54Z","comment"=>"Testing pages with parenthesis in the name",
    #     "tags"=>["wikieditor"]}
    # EDITED -
    # {"type"=>"edit","ns"=>828,"title"=>"Module:Swatches/data","pageid"=>14088,"revid"=>40201,
    #     "old_revid"=>40085,"rcid"=>45599,"user"=>"Sorahawk","userid"=>2984,"oldlen"=>1557,"newlen"=>6383,
    #     "timestamp"=>"2026-02-05T17:17:17Z","comment"=>"added new Swatches.[...]","tags"=>[]},
    private

    def hook
      :PageContentSaveComplete
    end

    def page
      {
        message_key:,
        title: { prefixedText: changes[:title] },
        url: url_for(changes[:title]),
        summary: changes[:summary],
        revision: {
          size: changes.fetch(:newlen, 0) - changes.fetch(:oldlen, 0),
          diff: diff,
          minor: changes.key?(:minor),
        },
      }
    end

    def message_key
      "mentat-msg-page-#{changes[:type] == "new" ? "created" : "edited"}"
    end

    def diff
      params = { title: changes[:title], curid: changes[:pageid], diff: 'prev', oldid: changes[:old_revid] }
      diff_page = "index.php?#{params.map { |k, v| "#{k}=#{v}" }.join("&")}"
      url_for(diff_page)
    end
  end
end
