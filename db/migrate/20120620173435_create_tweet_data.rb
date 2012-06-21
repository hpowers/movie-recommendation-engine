class CreateTweetData < ActiveRecord::Migration
  def change
    create_table :tweet_data do |t|
      t.integer :num, default: 0
      t.references :movie

      t.timestamps
    end
    add_index :tweet_data, :movie_id
  end
end
