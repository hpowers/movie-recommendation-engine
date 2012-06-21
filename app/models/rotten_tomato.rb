class RottenTomato < ActiveRecord::Base
  belongs_to :movie
  attr_accessible :score
end
