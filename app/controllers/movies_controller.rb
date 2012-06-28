class MoviesController < ApplicationController

  def index
    redirect_to movie_path(1) 
  end

  def show

    @id = params[:id].to_i

    zip_code = cookies[:zip_code]

    if !zip_code.nil?
      redirect_to movie_theater_path( @id, zip_code )
    end

    @ranking = @id

    movies = Movie.released.min_score.where(default: true)

    @movie = movies[@ranking-1]

    @ranking = 0 if @ranking == movies.size

    
  end
end
