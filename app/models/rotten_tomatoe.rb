class RottenTomatoe < ActiveRecord::Base
  belongs_to :movie
  attr_accessible :score
end
