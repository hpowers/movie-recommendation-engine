namespace :db do
  desc "scores the db"
  task score: :environment do

    Movie.all.each do |movie|
      
      movie.score = movie.rt_datum.critics_score

      days_ago = ( Date.today - movie.rt_datum.release_date ).to_i
      
      weeks_ago = ( days_ago / 7 ).ceil

      if weeks_ago <= 2
        movie.score = (movie.score * 1.2).to_i
      end

      if weeks_ago > 4
        (weeks_ago - 4).times do
          movie.score = (0.95 * movie.score).to_i
        end
      end

      movie.score = movie.score.abs

      movie.save

    end
    
  end
end