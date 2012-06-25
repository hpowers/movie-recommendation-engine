class MoviesController < ApplicationController

  def index
    
    @movies = Movie.where(default: true)
    # @movies = Movie.all

  end

end
