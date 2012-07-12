class AddScoreAdjustmentsToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :score_adjustment, :integer, default: 0, null: false
  end
end
