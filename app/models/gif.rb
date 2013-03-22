class Gif < ActiveRecord::Base
  attr_accessible :datetime, :downvotes, :upvotes, :url
end
