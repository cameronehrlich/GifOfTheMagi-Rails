require 'open-uri'
require 'nokogiri'

class ProcessController < ApplicationController

  def index
    respond_to do |format|
      format.html
    end
  end

  def scrape
    urls = getGifsFromSubreddit('reactiongifs')
    urls2 = getGifsFromSubreddit('shittyreactiongifs')
    urls.concat(urls2)
  	
    #FOR DEVELOPMENT PURPOSES ONLY
    # urls = urls[0,5]

    @newImages = 0
    @foundImages = 0

    urls.each do |u|
		  record = Images.where( orig_url: u ).first
  		if record == nil
  		 	p = Images.new
        p.image_from_url  u
        p.image_file_name = "g.gif"
  	   	p.save
  	   	@newImages += 1
  		else
  			@foundImages += 1
  		end
	 end
    respond_to do |format|
      format.html
    end
  end

  def feed
	# This can be optimized hard core
  	@images = Images.order("image_updated_at DESC")
  	if params[:start] == nil or params[:end] == nil
  		@images = @images[0,30];
  	else
  		s = params[:start].to_i
  		e = params[:end].to_i

  		@images = @images[s, e]
  	end
  	
  	respond_to do |format|
  		format.html
  		format.json {render :json => @images }
  	end
  end

  def update
    @id = params[:id]
    @operation = params[:operation]

    if @operation == "remove"
      Images.destroy(@id)
      @message = "removed #{@id}"
    elsif @operation == "removeall"
      Images.destroy_all()
      @message = "removed all!"
    end
  end


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

end
