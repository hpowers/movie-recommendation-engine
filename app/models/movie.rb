class Movie < ActiveRecord::Base
  has_one :rt_datum    , dependent: :destroy
  has_one :imdb_datum  , dependent: :destroy
  has_one :tweet_datum , dependent: :destroy
  has_one :ebert_datum , dependent: :destroy
  has_one :hsx_datum   , dependent: :destroy
  
  attr_accessible :default, :score, :title

  default_scope order("score DESC")
  default_scope where(released: true)
  # default_scope where('score > ?',1)
  # default_scope limit(10)
  default_scope where('score > ?',40)
end
