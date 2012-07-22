# This is a preliminary rating algorithm.

module Scoring

  def self.score(movie)
    # the base score comes from the Rotten Tomato score
    movie.score = movie.rt_datum.critics_score

    # # unless the films lacks a critics consensus (it's in very limited release)
    if movie.rt_datum.critics_consensus.nil?
      # in which case we base the score on metacritic
      movie.score = movie.imdb_datum.metacritic.to_i
    end

    # subtract 50% for G & PG movies
    mpaa_rating = movie.rt_datum.mpaa_rating
    if mpaa_rating == 'G' || mpaa_rating == 'PG'
      movie.score = (0.50 * movie.score).to_i
    end

    # subtract 20% for Unrated
    if mpaa_rating == 'Unrated'
      movie.score = (0.80 * movie.score).to_i
    end    

    # subtract 15% for movies trading low (counter art-house effect)
    if movie.hsx_datum.price < 10
      movie.score = (0.85 * movie.score).to_i
    end

    # if a film is in it's first 2 weeks add 20%
    days_ago = ( Date.today - movie.rt_datum.release_date ).to_i
    weeks_ago = ( days_ago / 7 ).ceil
    if weeks_ago <= 2
      movie.score = (movie.score * 1.2).to_i
    end

    # If a film is older than 3 weeks, subtract 5% for each week greater
    if weeks_ago > 3
      (weeks_ago - 3).times do
        movie.score = (0.95 * movie.score).to_i
      end
    end

    # no negative scores
    movie.score = 0 if movie.score < 1

    # # multiple by adjustment
    movie.score *= movie.score_adjustment / 100.0 + 1

    movie.save
  end
  
end
