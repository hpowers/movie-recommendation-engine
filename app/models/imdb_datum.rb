class ImdbDatum < ActiveRecord::Base
  belongs_to      :movie
  attr_accessible :budget, :length, :metacritic, :movie_meter, :release,
                  :title,  :viewer
end
