class TheatersController < ApplicationController

  def show

    @zip_code = params[:id].to_i

    if params[:movie_id][0..1] == 'id'

      id = params[:movie_id][2..-1]

      @movie = Movie.find( id )
      @ranking = 0

      theater_data = Fandango.movies_near(@zip_code)
      movies = Movie.released.select {|movie| theater_data.to_s.include? movie[:title]}

      @ranking = 1 if @movie == movies[0]

    else

      @movie_id = params[:movie_id].to_i
      @ranking  = @movie_id

      # movies = Movie.released.min_score.where(default: true)
      # filter results by films playing in zip
      theater_data = Fandango.movies_near(@zip_code)

      movies = Movie.released.select {|movie| theater_data.to_s.include? movie[:title]}
      
      @movie = movies[@ranking - 1]

      @ranking = 0 if @ranking == movies.size

    end

    

    # filter results by films playing in zip
    # theater_data = Fandango.movies_near(20024)
    # @movies = Movie.all.select {|movie| theater_data.to_s.include? movie[:title]}

    

    
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

    cookies.delete(:zip_code)
    redirect_to movie_path(@movie_id)

  end
end
