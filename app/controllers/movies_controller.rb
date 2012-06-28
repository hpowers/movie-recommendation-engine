class MoviesController < ApplicationController

  def index
    redirect_to movie_path(1) 
  end

  def show

    @id = params[:id]

    # if user has zip code stored, redirect to page with showtimes
    zip_code = cookies[:zip_code]

    if !zip_code.nil?
      redirect_to movie_theater_path( @id, zip_code )
    end

    if @id[0..1] == 'id'

      @id = @id[2..-1]

      @movie = Movie.find( @id )
      @ranking = 0

      @ranking = 1 if @movie == Movie.released.min_score.where(default: true).first
      
    else
      
      @ranking = @id.to_i

      movies = Movie.released.min_score.where(default: true)

      @movie = movies[@ranking-1]

      @ranking = 0 if @ranking == movies.size

    end
  end
end
