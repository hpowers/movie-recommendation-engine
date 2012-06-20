class Movie < ActiveRecord::Base
  has_many :rotten_tomatoes , dependent: :destroy
  has_many :imdb_data_points, dependent: :destroy
  has_many :tweets          , dependent: :destroy
  has_many :ebert_stars     , dependent: :destroy
  has_many :hsx_data_points , dependent: :destroy
  
  attr_accessible :default, :score, :title
end
