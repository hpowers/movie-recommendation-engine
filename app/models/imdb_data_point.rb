class ImdbDataPoint < ActiveRecord::Base
  attr_accessible :budget, :length, :metacritic, :movie_meter, :release, :title, :viewer
end
