class Movie < ActiveRecord::Base
  has_one :rt_datum    , dependent: :destroy
  has_one :imdb_datum  , dependent: :destroy
  has_one :tweet_datum , dependent: :destroy
  has_one :ebert_datum , dependent: :destroy
  has_one :hsx_datum   , dependent: :destroy
  
  attr_accessible :default, :score, :title

  default_scope order("score DESC")
  
  scope :released, where(released: true)
  scope :default, where(default: true)
  
  # default_scope where('score > ?',1)
  # default_scope limit(10)
  
  scope :min_score, where('score > ?',40)
end
