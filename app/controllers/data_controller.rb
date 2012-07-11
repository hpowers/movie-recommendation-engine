class DataController < ApplicationController

  def index
    @movies = Movie.all
  end

end
