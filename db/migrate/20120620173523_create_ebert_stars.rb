class CreateEbertStars < ActiveRecord::Migration
  def change
    create_table :ebert_stars do |t|
      t.integer :stars, default: 0
      t.references :movie

      t.timestamps
    end
    add_index :ebert_stars, :movie_id
  end
end
