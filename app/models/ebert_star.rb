class EbertStar < ActiveRecord::Base
  belongs_to :movie
  attr_accessible :stars
end
