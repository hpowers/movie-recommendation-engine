# Builds recommendations based on movies playing in a specified zip code

class Recommendations

  attr_reader :title, :link, :showtimes, :ranking, :zip_code, :movie

  def initialize(request_number, zip=nil)

    @zip_code       = zip
    @request_number = request_number

    if @zip_code

      @data  = Fandango.movies_near(@zip_code)

      # select movies from the db playing in specified zip      
      movies = Movie.released.select {|movie| @data.to_s.include? movie[:title]}  

    else

      movies = Movie.released.min_score.where(default: true)

    end
    
    # check if request is for a specific id, oppose to general ranking request
    if @request_number[0..1] == 'id'

      # specific titles use a request format of 'id321' where 321 is the db id
      @movie = Movie.find( @request_number[2..-1] )
      
      # check if requested movie is equal to first recommendation.
      if @movie == movies[0]
        # adjust ranking to skip first recommendation
        @ranking = 1
      else
        @ranking = 0
      end

    else

      @ranking = @request_number = @request_number.to_i
      @movie   = movies[@request_number - 1]
      
      # reset ranking if this is the last movie on the list
      @ranking = 0 if @request_number == movies.size

    end
  end

  def title
    @movie.title
  end

  def showtimes(theater)

    # lowercased space free version of the theatre name with special id
    theater_identity = theater[:name].gsub(/\W/,'').downcase + '_' + theater[:id]

    theater_url  = "http://www.fandango.com/#{theater_identity}/theaterpage"
    theater_page = Nokogiri::HTML(open(theater_url))

    # the page has showtimes for every movie.  find ones that match our title
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

    # make sure showtimes are in chronological order
    return showtimes_hash.sort_by do | time , url |
      Time.parse(time.gsub(/a/,'am').gsub(/p/,'pm'))
    end

  end

  def showtime_information

    informatation_array = []
    
    theaters.each do |theater|
      informatation_array << { theater: theater, showtimes: showtimes(theater) }
    end
    
    informatation_array
  end

  def theaters(limit=3)

    theater_data = @data
    theater_list = []

    theater_data.each do |theater_hash|

      # see if the movie is playing in a theater
      if theater_hash[:movies].find{|movie| movie[:title].include? title}
        # add theater to the list
        theater_list.push(theater_hash[:theater])
      end

    end

    theater_list[0,limit]
  end
end