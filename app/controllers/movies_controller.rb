require 'recommendations'
require 'score'

class MoviesController < ApplicationController

  def index
    redirect_to movie_path(1) 
  end

  # caches_page :show

  def show

    @id      = params[:id]
    zip_code = cookies[:zip_code]
    
    if !zip_code.nil?
      redirect_to movie_theater_path( @id, zip_code )
    end

    @recommendation = Recommendations.new( params[:id] )

  end

  def update

    # # expire cache
    # Movie.released.min_score.default.count.times do |movie|
    #   expire_page movie_path(movie+1)
    # end

    id = params[:id]

    movie = Movie.find(id)
    
    movie.score_adjustment = params[:update][:score_adjustment].to_i

    movie.save

    Scoring.score(movie)

    render :text => movie.score
    
  end

end
