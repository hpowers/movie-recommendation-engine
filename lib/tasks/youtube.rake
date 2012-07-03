namespace :db do

  desc "finds trailer for movie in db"

  task youtube: :environment do

    require 'open-uri'
    require 'net/http'

    def search(title)
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

    # find the trailers
    Movie.all.each do |movie|

      if !movie.videoid
        movie.videoid = search (movie.title)

        if movie.videoid == nil
          puts "trailer not found for #{movie.title}"
        end

        movie.save
      end
    end

  end
end