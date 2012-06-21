require 'net/http'
require 'open-uri'

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

      RtDatum.find_or_create_by_movie_id( active_movie ) do | rotten | 
        
        rotten.runtime           = rotten_record['runtime']
        rotten.mpaa_rating       = rotten_record['mpaa_rating']
        rotten.critics_consensus = rotten_record['critics_consensus']
        rotten.critics_score     = rotten_record['ratings']['critics_score']
        rotten.audience_score    = rotten_record['ratings']['audience_score']
        rotten.movie_id          = active_movie.id
        
        rotten.release_date      = Date.parse( 
                                   rotten_record['release_dates']['theater'])
      end

      active_movie.touch

    end
  end
end

module UpdateTweet

  def self.num(movies)

    movies.each do |movie|
      
      search_for = URI.escape( "#{movie.title} site:twitter.com" )

      search_url = "http://www.google.com/search?q=#{search_for}"
      search_data = Nokogiri::HTML(open(search_url))

      num_tweets = 0
      search_data.to_s.force_encoding("UTF-8").lines.each do |line|
        
        if line.match(/About.+results/)

          num_tweets = line.gsub(/\D/,'').to_i
          break;

        end
      end

      TweetDatum.find_or_create_by_movie_id( movie.id ) do | tweet |
        tweet.num = num_tweets
      end
    end
  end
end

namespace :db do
  desc "updates the db"
  task update: :environment do
    
    UpdateRottenTomato.in_theaters
    # UpdateRottenTomato.opening

    movies = Movie.all

    UpdateTweet.num(movies)


  end
end
