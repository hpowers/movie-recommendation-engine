require 'recommendations'

class MoviesController < ApplicationController

  def index
    redirect_to movie_path(1) 
  end

  def show

    @id      = params[:id]
    zip_code = cookies[:zip_code]
    
    if !zip_code.nil?
      redirect_to movie_theater_path( @id, zip_code )
    end

    @recommendation = Recommendations.new( params[:id] )

  end

  def update
    id = params[:id]

    movie = Movie.find(id)
    
    movie.score_adjustment = params[:update][:score_adjustment].to_i

    movie.save
  end

end
