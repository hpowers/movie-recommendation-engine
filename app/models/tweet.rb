class Tweet < ActiveRecord::Base
  belongs_to :movie
  attr_accessible :num
end
