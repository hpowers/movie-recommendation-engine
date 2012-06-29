class Recommendations

  attr_reader :title, :link, :showtimes, :id, :ranking, :zip_code

  def initialize( request_number, zip )
    @zip_code = zip.to_i
    @data = Fandango.movies_near(@zip_code)

    movies = Movie.released.select {|movie| @data.to_s.include? movie[:title]}

    @request_number = request_number
    if @request_number[0..1] == 'id'

      movie = Movie.find( @request_number[2..-1] )
      
      @title = movie.title
      @id = movie.id
      
      if movie == movies[0]
        @ranking = 1
      else
        @ranking = 0
      end

    else
      @request_number = @request_number.to_i
      
      movie = movies[@request_number - 1]
      @title = movie.title
      @id = movie.id
      
      if @request_number == movies.size
        @ranking = 0
      else
        @ranking = @request_number
      end

    end

  end

  def showtimes(theater)

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
    theater_data = @data
    theater_list = []

    theater_data.each do |theater_hash|
      # see if the movie is playing in a theater
      # movie_found = theater_hash[:movies].find{|movie| movie[:title]==title}
      movie_found = theater_hash[:movies].find{|movie| movie[:title].include? title}

      theater_list.push(theater_hash[:theater]) if movie_found
    end

    return theater_list[0,limit]
  end

end