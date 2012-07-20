class DataController < ApplicationController
  before_filter :authenticate

  def index
    @movies = Movie.released
  end

end
