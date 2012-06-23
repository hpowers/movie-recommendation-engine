require 'net/http'
require 'open-uri'


# This module updates the db with the latest information from Rotten Tomatoes
# In addition to updating the rt_data table, these methods build the movie list
# The self.in_theaters method sets the URL to the API feed for released movies
# The self.opening methods sets the URL to the API feed to upcoming US movies
# The self.process_urk method parses the API data and updates the db tables

module UpdateRottenTomato

  @key = ENV["TOMATOES_API"]
  @limit = 10

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
      active_movie.touch

      rotten = RtDatum.find_or_create_by_movie_id( active_movie )

      rotten.runtime           = rotten_record['runtime']
      rotten.mpaa_rating       = rotten_record['mpaa_rating']
      rotten.critics_consensus = rotten_record['critics_consensus']
      rotten.critics_score     = rotten_record['ratings']['critics_score']
      rotten.audience_score    = rotten_record['ratings']['audience_score']
      rotten.movie_id          = active_movie.id
      rotten.release_date      = Date.parse( 
                                 rotten_record['release_dates']['theater'])
      
      rotten.save
    end
  end
end


# This module gets rid of movies that are no longer relevant
# The self.old_movies method finds any Movie older than the timestamp and 
# puges it

module Purge
  
  def self.old_movies(time)
    Movie.where(["created_at < ?", time]).destroy_all
  end
end


# This module updates the db with the number of tweets with the movie's title
# The self.num method does a google search scoped to twitter and parses the 
# results.

module UpdateTweet

  def self.num(movies)

    movies.each do |movie|
      
      search_for = URI.escape( "#{movie.title} site:twitter.com" )

      search_url = "http://www.google.com/search?q=#{search_for}"
      search_data = Nokogiri::HTML(open(search_url))

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
# contains methods to find targetd bits of information.  The self.process method
# loops through a list of movies and creates Imdb objects for each movie finding
# and recording said bits of information in the db.

module UpdateImdb
  
end

namespace :db do

  desc "updates the db"

  task update: :environment do
    # grab a timestamp to delete old movies with
    start_time = Time.now - 5

    # update the movie list and rotten tomato data
    # UpdateRottenTomato.in_theaters
    # UpdateRottenTomato.opening

    # Purge.old_movies(start_time)

    # store movies to avoid excess db calls
    movies = Movie.all

    # update remaining sources
    UpdateTweet.num(movies)
    # UpdateImdb.data(movies)
    # UpdateEbert.stars(movies)
    # # this method also sets movie's defaul status
    # UpdateHsx.data(movies)

    # calculate scores (initially just copy their critics_score)
    # UpdateScores.all
  end
end
