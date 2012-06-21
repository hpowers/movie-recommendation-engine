class TweetDatum < ActiveRecord::Base
  belongs_to      :movie
  attr_accessible :num
end
