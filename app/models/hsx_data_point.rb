class HsxDataPoint < ActiveRecord::Base
  belongs_to :movie
  attr_accessible :gross, :price, :theaters
end
