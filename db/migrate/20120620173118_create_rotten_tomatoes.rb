class CreateRottenTomatoes < ActiveRecord::Migration
  def change
    create_table :rotten_tomatoes do |t|
      t.integer :score, default: 0
      t.references :movie

      t.timestamps
    end
    add_index :rotten_tomatoes, :movie_id
  end
end
