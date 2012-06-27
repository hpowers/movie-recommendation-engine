class RankingsController < ApplicationController

  def index
    redirect_to ranking_path(1) 
  end

  def show

    @rank = params[:id].to_i

    movies = Movie.released.min_score.where(default: true)

    @movie = movies[@rank-1]

    @rank = 0 if @rank == movies.size

  end

end
