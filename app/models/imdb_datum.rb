class ImdbDatum < ActiveRecord::Base
  belongs_to      :movie
  attr_accessible :budget, :metacritic, :movie_meter, :title, :viewer
end
