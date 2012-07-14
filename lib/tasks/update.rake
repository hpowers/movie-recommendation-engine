require 'net/http'
require 'open-uri'


# This module contains methods useful for parsing.  
# The self.similar method looks for similiar words in two strings.

module Utilities

  def self.similiar?( string1, string2, threshold = 50 )
    
    string1 = string1.downcase.gsub(/[^\w\s]/,'')
    string2 = string2.downcase.gsub(/[^\w\s]/,'')

    return true if string1 == string2

    string1_words  = string1.split(' ')

    sim_word_count = 0

    string1_words.each do | word |
      sim_word_count += 1 if string2.include? word
    end

    puts sim_word_count
    puts string2.split(' ').size

    threshold_test = sim_word_count.to_f / string2.split(' ').size * 100
    puts threshold_test

    if threshold_test >= threshold
      puts "true: #{string2}"
      return true
    else
      puts "false: #{string2}"
      return false
    end

  end
  
end


# This module updates the db with the latest information from Rotten Tomatoes
# In addition to updating the rt_data table, these methods build the movie list
# and remove old movies from the default list.
# The self.in_theaters method sets the URL to the API feed for released movies
# The self.opening methods sets the URL to the API feed to upcoming US movies
# The self.process_urk method parses the API data and updates the db tables

module UpdateRottenTomato

  @key = ENV["TOMATOES_API"]
  @limit = 50

  def self.in_theaters
    url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/"+
          "in_theaters.json?page_limit=#{@limit}&apikey=#{@key}"
    proccess_url(url)
  end

  def self.opening
    url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/"+
          "opening.json?limit=#{@limit}&country=us&apikey=#{@key}"
    proccess_url(url)
  end

  def self.proccess_url(url)
    
    in_theater_list = JSON.parse( Net::HTTP.get_response( URI( url ) ).body )
    in_theater_list["movies"].each do | rotten_record |

      active_movie = Movie.find_or_create_by_title( rotten_record['title'] )

      rotten = RtDatum.find_or_create_by_movie_id( active_movie )

      rotten.runtime           = rotten_record['runtime']
      rotten.mpaa_rating       = rotten_record['mpaa_rating']
      rotten.critics_consensus = rotten_record['critics_consensus']
      rotten.critics_score     = rotten_record['ratings']['critics_score']
      rotten.audience_score    = rotten_record['ratings']['audience_score']
      rotten.movie_id          = active_movie.id
      rotten.release_date      = Date.parse( 
                                 rotten_record['release_dates']['theater'])

      # remove old movies from default status
      if Date.today - rotten.release_date > 60
        active_movie.default = false
      end

      # denote if a movie is released
      if rotten.release_date < Date.today
        active_movie.released = true
      end

      # find YouTube trailer
      if !active_movie.videoid
        active_movie.videoid = YouTube.search(active_movie.title)
      end

      active_movie.save
      rotten.save
    end
  end
end


# This module gets rid of movies that are no longer relevant
# The self.old_movies method finds any Movie older than the timestamp and 
# puges it

module Purge
  
  def self.old_movies(time)
    Movie.where(["updated_at < ?", time]).destroy_all
  end
end


# This module updates the db with the number of tweets with the movie's title
# The self.num method does a google search scoped to twitter and parses the 
# results.

module UpdateTweet

  def self.num(movies)

    movies.each do |movie|

      puts "counting tweets for #{movie.title}"      
      search_for = URI.escape( "#{movie.title} site:twitter.com" )

      search_url = "http://www.google.com/search?q=#{search_for}"
      search_data = Nokogiri::HTML(
                    open(search_url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))

      num_tweets = 0
      # ruby hangs on the returned data if the title is greater than 2 words
      # due to an odd character encoding rectified by forcing utf-8
      search_data.to_s.force_encoding("UTF-8").lines.each do |line|
        
        if line.match(/About.+results/)

          num_tweets = line.gsub(/\D/,'').to_i
          break
        end
      end

      tweet     = TweetDatum.find_or_create_by_movie_id( movie.id )
      tweet.num = num_tweets
      tweet.save
    end
  end
end


# This module updates the db with information from IMDB.  The Imdb class
# contains methods to find targetd bits of information.  The self.data method
# loops through a list of movies and creates Imdb objects for each movie finding
# and saving said bits of information to the db.

module UpdateImdb

  class Imdb  

    attr_accessor :url

    def initialize(name,search_url='')

      puts "searching imdb for #{name}"

      @url = search_url

      if search_url.empty?

        puts "using google"

        search_for = URI.escape(name)
      
        search_url = "http://www.google.com/search?q=#{search_for}+imdb&btnI=3564"

        search_file = open(search_url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)

        # figure out where we were redirected to
        final_url = search_file.base_uri.to_s
        
        if final_url.include? "www.imdb.com/title"
          # extract the unique identifier from the URL
          @url = final_url[26..-2]

        end

      else
        puts "calling direct"
        # a url was provided for us, just use that
        search_file = open("http://www.imdb.com/title/#{@url}/", 
                            ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
      end

      @search_data = Nokogiri::HTML(search_file)

    end

    # title of movie according to IMDB
    def title
      begin

        title = @search_data.at_css('#title-overview-widget h1.header')
                            .text.strip

        rem_title = @search_data.at_css('#title-overview-widget h1.header .nobr')
                                .text.strip

        title.gsub(rem_title,'').strip

      rescue NoMethodError => e
        ''
      end
    end

    # how IMDB visitors rated the movie
    def viewer_score
      begin

        viewer_score = @search_data
                      .at_css('#title-overview-widget .star-box-giga-star')
        (viewer_score.text.strip.to_f * 10).to_i

      rescue NoMethodError => e
        0
      end
    end

    # average critic rating of movie
    def metacritic_score

      metacritic = nil
      begin

        @search_data.css('.star-box-details a').each do |link|

          if link[:href]=="criticreviews" && link.text.strip.match(/\/100/)

            metacritic = link.text.strip.to_i

            return metacritic
          end
        end
        return metacritic     

      rescue NoMethodError => e
        metacritic
      end
    end

    # how oftend the movie is searched for on IMDB
    def movie_meter
      begin

        @search_data.at_css('a#meterRank.top100').text.strip

      rescue NoMethodError => e
        0
      end
    end

    # production budget
    def budget

      budget = nil
      begin

        @search_data.css('#maindetails_center_bottom .txt-block').each do |block|

          if block.at_css('h4.inline')

            if block.at_css('h4.inline').text.strip == "Budget:"
              budget = block.text.strip.gsub(/\D/,'').to_i
              return budget
            end

          end
        end
        return budget

      rescue NoMethodError => e
        nil
      end
    end

    # average power rating of top 2 billed stars
    def star_power
      # not implemented
    end
  end

  def self.data(movies)

    movies.each do |movie|

      imdb_datum = ImdbDatum.find_or_create_by_movie_id( movie.id )
      imdb       = Imdb.new(movie.title,imdb_datum.url)

      imdb_datum.title       = imdb.title
      imdb_datum.viewer      = imdb.viewer_score
      imdb_datum.metacritic  = imdb.metacritic_score
      imdb_datum.movie_meter = imdb.movie_meter
      imdb_datum.budget      = imdb.budget
      imdb_datum.url         = imdb.url

      imdb_datum.save
    end
  end
end

# This module finds trailers for movies on YouTube.
# The search method takes a tile and returns a YoutTube videoid for the trailer

module YouTube

  def self.search(title)
    
      url = "http://gdata.youtube.com/feeds/api/videos?"+
            "q=#{title}+trailer&max-results=10&v=2&alt=json"

      url      = URI.escape(url)

      response = JSON.parse( Net::HTTP.get_response( URI( url ) ).body )

      response["feed"]["entry"].each do |movie|

        # if movie["title"]["$t"].include?(title)
          return movie["media$group"]["yt$videoid"]["$t"] 
        # end
      end

      return nil

  end
end


# This module updates the db with the number of "stars" Roger Ebert gave a movie
# in his review.  The Ebert class uses google to find Ebert's review of a movie.
# The verified_review? method makes sure the page is actually a review page.
# The count_stars method counts the star images on the page to determine Ebert's
# ranking.  The self.stars method itterates through the movies, creating and
# updating the ebert_datum.  

module UpdateEbert
  
  class Ebert

    def initialize(title)

      puts "searching Ebert for #{title}"

      search_for   = URI.escape(title)
      search_url   = "http://duckduckgo.com/?q=!ducky%20#{search_for}+"+
                     "review+site:rogerebert.suntimes.com"

      search_file = open(search_url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)

      # DuckDuck redirects using JS
      final_url = search_file.string.match(/replace\('.+'\)/).to_s[9..-3]

      search_file = open(final_url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)

      @data        = Nokogiri::HTML(search_file)

    end

    def verified_review?
      @data.at_css('title').text.include? ':: Reviews'
    end

    def count_stars

      stars = 0.0

      if verified_review?

        puts "found review"

        image_block = @data.to_s[/<b> Ebert:<\/b>.+<b>Users:<\/b>/m]
        image_block = Nokogiri::HTML(image_block)

        image_block.css('img').each do |img|

          case img[:src]

            when "/graphics/redstar_matte_tan_transp.gif"
              stars += 1

            when "/graphics/redstar_half_tan_matte.gif"
              stars += 0.5

          end
        end   
      end
      return stars
    end  
  end  

  def self.stars(movies)

    movies.each do |movie|

      ebert_datum = EbertDatum.find_or_create_by_movie_id( movie.id )

      if ebert_datum.stars < 0.5

        ebert             = Ebert.new(movie.title)
        ebert_datum.stars = ebert.count_stars
        ebert_datum.save

      end
    end
  end
end


# This module updates the db with information from the Hollywood Stock Exchange.  
# The Hsx class contains methods to find targetd bits of information.  
# The self.data method loops through a list of movies and creates Hsx objects
# for each movie finding and saving said bits of information to the db.

module UpdateHsx

  class Hsx

    attr_accessor :url

    def initialize(name,search_url='')

      puts "searching HSX for #{name}"

      @url = search_url

      if search_url.empty?

        puts 'using google'

        search_for = "HSX.com MovieStock : #{name} site:hsx.com"
        search_for = URI.escape(search_for)
      
        search_url = "http://www.google.com/search?q=#{search_for}&btnI=3564"

        search_file = open(search_url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)

        # figure out where we were redirected to
        final_url = search_file.base_uri.to_s
        
        if final_url.include? "hsx.com/security/view"
          # extract the unique identifier from the URL
          @url = final_url.gsub(/.+\//,'').gsub(/\..+/,'')

        end

      else
        puts 'direct call'
        # a url was provided for us, just use that
        search_file = open("http://www.hsx.com/security/view/#{@url}", 
                      ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
      end

      @search_data = Nokogiri::HTML(search_file)

    end

    def title
      title = @search_data.at_css('title').text[23..-1]
      if !title.nil?
        return title
      else
        return ''
      end
    end

    def price

      begin

        price = @search_data.at_css('.security_summary p.value').text.strip
        rem_price = @search_data.at_css('.security_summary p.value span').text.strip

        price = price.gsub(rem_price,'').strip
        price.gsub(/[^0-9.]/, "").to_f 

      rescue NoMethodError => e
        0
      end
    end

    def gross

      begin

        gross = 0
        @search_data.css('.data_column.last tr').each do |block|

          if block.at_css('td.label').text == "Gross:"
            gross = block.at_css('td:nth-child(2)').text.gsub(/\D/,'').to_i

            return gross
          end
        end

        return gross      

      rescue NoMethodError => e
        0
      end
    end

    def theaters

      begin
        
        theaters = 0
        @search_data.css('.data_column.last tr').each do |block|

          if block.at_css('td.label').text == "Theaters:"

            theaters = block.at_css('td:nth-child(2)').text.to_i
            return theaters

          end
        end

        return theaters

      rescue NoMethodError => e
        0
      end
    end
  end

  def self.data(movies)

    movies.each do |movie|

      hsx_datum = HsxDatum.find_or_create_by_movie_id( movie.id )
      hsx       = Hsx.new(movie.title, hsx_datum.url)

      # be reasonably sure we're on the right page
      if Utilities.similiar?(movie.title,hsx.title)

        hsx_datum.price    = hsx.price
        hsx_datum.gross    = hsx.gross
        hsx_datum.theaters = hsx.theaters
        hsx_datum.url      = hsx.url
        
        # check if movie qualifies for "default" status
        days_ago = Date.today - movie.rt_datum.release_date

        if hsx_datum.theaters > 500 && movie.default == false && days_ago <= 60
          movie.default = true
          movie.save
        end

        hsx_datum.save
        
      end
    end
  end  
end

class DeCnt
  def initialize
    @count = 0
    @time = Time.now
    go
  end
  def go(msg='')
    @count += 1
    puts "DeCnt Call #{@count}) #{msg} (+#{(Time.now - @time).to_i}s)"
    @time = Time.now
  end
end

namespace :db do

  desc "updates the db"

  task update: :environment do

    begin
        
      # this is a logger method to help see where thing go awry
      decnt = DeCnt.new

      # grab a timestamp to delete old movies with
      start_time = Time.now - 5

      # update the movie list, trailers, and rotten tomato data
      UpdateRottenTomato.in_theaters
        decnt.go('tomato theaters')
      UpdateRottenTomato.opening
        decnt.go('tomato opening')

      # Purge.old_movies(start_time)
        decnt.go('purged')

      # store movies to avoid excess db calls
      movies = Movie.all
        decnt.go('movie list complete')

      # update remaining sources
      UpdateImdb.data(movies)
        decnt.go('imdb')
      UpdateEbert.stars(movies)
        decnt.go('ebert')
      # this method also sets movie's default status
      UpdateHsx.data(movies)
        decnt.go('hsx')
      # disabled to not irittate the google gods
      # UpdateTweet.num(movies)

      # calculate scores
      Rake::Task['db:score'].execute
        decnt.go('score')

    rescue Exception => e
      
      puts e
      puts "now email someone #{output}"

    end


  end
end
