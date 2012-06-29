require 'recommendations'

class TheatersController < ApplicationController

  def show

    @recommendation = Recommendations.new( params[:movie_id], params[:id]  )

  end

  def create

    @movie_id = params[:movie_id].to_i
    @zip_code = params[:theaters][:zip].to_i
    @id       = params[:theaters][:movie_id]

    # make sure it looks like a zip code
    if @zip_code.to_s.length <= 4
      destroy
    else
      cookies.permanent[:zip_code] = @zip_code
      redirect_to movie_theater_path( @id, @zip_code )
    end

  end

  def destroy
    @id = params[:theaters][:movie_id]

    cookies.delete(:zip_code)
    redirect_to movie_path(@id)

  end

end


