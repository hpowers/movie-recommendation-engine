require 'recommendations'

class TheatersController < ApplicationController

  def show
    # cookies.delete(:zip_code)
    @recommendation = Recommendations.new( params[:movie_id], params[:id] )
  end

  def create

    @zip_code = params[:theaters][:zip]

    if @zip_code.to_i.to_s.length == 5

      cookies.permanent[:zip_code] = @zip_code.to_i
      redirect_to movie_theater_path( params[:theaters][:movie_id] , @zip_code )

    else
      # kill it with fire
      destroy
    end

  end

  def destroy

    cookies.delete(:zip_code)
    redirect_to movie_path( params[:theaters][:movie_id] )

  end
end

