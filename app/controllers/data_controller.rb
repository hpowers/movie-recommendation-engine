class DataController < ApplicationController

  def index
    @movies = Movie.released
  end

end
