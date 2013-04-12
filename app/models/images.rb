require "open-uri"

class Images < ActiveRecord::Base
	attr_accessible :orig_url
  has_attached_file :image, :styles => {:original => "150x150>"}

  	def image_from_url(url)
  		self.orig_url = url
  		# self.image = URI.parse(url) if i want the original name
      self.image = open(url)
  	end
 	
 	def image_url
        return image.url
    end

end
