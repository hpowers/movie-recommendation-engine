class RtDatum < ActiveRecord::Base
  belongs_to      :movie
  
  attr_accessible :release_date, :runtime, :mpaa_rating, 
                  :critics_consensus, :critics_score,
                  :audience_score
end
