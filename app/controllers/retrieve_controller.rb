class RetrieveController < ApplicationController
require 'open-uri'
  def getGifsFromSubreddit(subreddit)
    urls = []
    url = "http://www.reddit.com/r/" + subreddit
    doc = Nokogiri::HTML(open(url))
    doc.css("div.thing").each do |item|
      nsfw = item.at_css("li.nsfw-stamp")
      u = item.at_css("a.title")[:href]
      if !nsfw && /.gif$/.match(u)
        urls.push(u)
      end
    end
  
    return urls
  end

  def index
  	@urls = getGifsFromSubreddit('shittyreactiongifs')
    @urls2 = getGifsFromSubreddit('reactiongifs')
    
    @urls.concat(@urls2)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @urls }
    end

  end
end
