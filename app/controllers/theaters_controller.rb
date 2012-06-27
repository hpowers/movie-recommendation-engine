class TheatersController < ApplicationController

  def show
    @rank = params[:id].to_i

    movies = Movie.released.min_score.where(default: true)

    @movie = movies[@rank-1]

    @rank = 0 if @rank == movies.size
  end

end
