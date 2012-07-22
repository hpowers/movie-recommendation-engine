class DataController < ApplicationController
  before_filter :authenticate

  def index
    @movies = Movie.joins(:hsx_datum).where('theaters > 1')
  end

end
