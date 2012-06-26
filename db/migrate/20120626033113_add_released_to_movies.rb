class AddReleasedToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :released, :boolean, default: false
  end
end
