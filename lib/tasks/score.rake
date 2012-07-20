require 'score'

namespace :db do
  desc "scores the db"
  task score: :environment do

    # expire cache
    Movie.released.min_score.default.count.times do |movie|
      path = "/movies/#{movie+1}"
      ApplicationController.expire_page path
    end

    Movie.all.each do |movie|
      
      # scoring logic is in /lib/score.rb
      Scoring.score(movie)

    end
    
  end
end
