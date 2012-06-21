require 'net/http'

module UpdateTomato
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

      RtDatum.find_or_create_by_movie_id( active_movie.id ) do | rotten | 
        
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

namespace :db do
  desc "updates the db"
  task update: :environment do
    
    UpdateTomato.in_theaters
    # UpdateTomato.opening

  end
end
