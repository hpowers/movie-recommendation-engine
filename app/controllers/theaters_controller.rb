class TheatersController < ApplicationController

  def show

    @zip_code = params[:id].to_i
    @id       = params[:movie_id]

    # if the id is prefixed by id, we are forcing a movie by its db id
    if @id[0..1] == 'id'

      @id = @id[2..-1]

      @movie = Movie.find( @id )
      @ranking = 0

      theater_data = Fandango.movies_near(@zip_code)
      movies = Movie.released.select {|movie| theater_data.to_s.include? movie[:title]}

      @ranking = 1 if @movie == movies[0]

    else

      @movie_id = @id.to_i
      @ranking  = @movie_id

      # filter results by films playing in zip
      theater_data = Fandango.movies_near(@zip_code)

      movies = Movie.released.select {|movie| theater_data.to_s.include? movie[:title]}
      
      @movie = movies[@ranking - 1]

      @ranking = 0 if @ranking == movies.size

    end

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


class Recommendations

  attr_reader :title, :link, :showtimes

  def initialize( request_number, zip = nil )
    update_list
    @recommendation_list = IO.readlines('movie_recommendations.txt')
    @request_number = request_number
    @zip = zip
    @link = Links.new( @request_number, @recommendation_list.size, @zip )
  end

  def update_list
    require 'json'
    require 'net/http'
    # Check for expired Rotten Tomatoe data
    data_expires = 12
    if (Time.now - File.mtime("movie_recommendations.txt"))/3600 > data_expires
      key = ENV["TOMATOES_API"] # Rotten Tomatoes API
      limit = 16 # movies to return
      url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?page_limit=#{limit}&apikey=#{key}"
      resp = Net::HTTP.get_response(URI(url))
      data = resp.body
      result = JSON.parse(data)

      # sort results by critics score descending.
      result["movies"].sort! {|a,b| b["ratings"]["critics_score"] <=> a["ratings"]["critics_score"]}

      list = []

      # store the titles in @list
      result["movies"].each {|m| list << m["title"]}

      update_recommendations = File.new("movie_recommendations.txt","w")
        update_recommendations.syswrite(list.join("\n"))
      update_recommendations.close
    end
  end

  def title
    @recommendation_list[@request_number-1].chomp
  end

  def showtimes(theater)
    require 'nokogiri'
    require 'open-uri'
    require 'time'

    # lowercased space free version of the theatre name with special id
    theater_identity = theater[:name].gsub(/\W/,'').downcase + '_' + theater[:id]

    theater_url = "http://www.fandango.com/#{theater_identity}/theaterpage"
    theater_page = Nokogiri::HTML(open(theater_url))

    matching_title = theater_page.css('#showtimes ul.showtimes').select do |movie|
      movie.at_css('h4 a').text.include?(title)
    end

    showtimes_hash = {}

    matching_title.each do |showtimes|
      # find showtimes for past shows and non ticketable shows
      showtimes.css('.times li.past','.times li.timeNonWired').each do |time|
        showtimes_hash[time.text]=''
      end

      # find showtimes & url for ticketable shows
      showtimes.css('.times a.showtime_itr').each do |time|
        showtimes_hash[time.at_css('.showtime_pop').text]=time[:href]
      end
    end

    # make sure we return a chronological hash
    return showtimes_hash.sort_by do | time , url |
      Time.parse(time.gsub(/a/,'am').gsub(/p/,'pm'))
    end

  end

  def showtime_information
    informatation_array = []
    theaters.each do |theater|
      informatation_array << {
        theater: theater,
        showtimes: showtimes(theater)
      }
    end
    return informatation_array
  end

  def theaters(limit=3)
    require 'fandango'
    theater_data = Fandango.movies_near(@zip)
    theater_list = []

    theater_data.each do |theater_hash|
      # see if the movie is playing in a theater
      movie_found = theater_hash[:movies].find{|movie| movie[:title]==title}
      theater_list.push(theater_hash[:theater]) if movie_found
    end

    return theater_list[0,limit]
  end

  # move between recommendations
  class Links
    attr_reader :next   

    def initialize( request_number , limit, zip=nil )
      zip = "/#{zip}" if zip # append zip to url if passed

      if request_number < limit
        @next = "/m#{request_number+1}#{zip}"
      elsif request_number == limit && zip # cycle back to first
        @next = "/m#{zip}"
      elsif request_number == limit
        @next = "/"
      end

    end
  end

end