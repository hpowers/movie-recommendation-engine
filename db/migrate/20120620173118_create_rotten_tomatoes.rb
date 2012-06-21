class CreateRottenTomatoes < ActiveRecord::Migration
  def change
    create_table :rotten_tomatoes do |t|
      t.date :release_date
      t.integer :runtime, default: 0
      t.string :mpaa_rating
      t.text :critics_consensus
      t.integer :critics_score, default: 0
      t.integer :audience_score, default: 0
      t.references :movie

      t.timestamps
    end
    add_index :rotten_tomatoes, :movie_id
  end
end
