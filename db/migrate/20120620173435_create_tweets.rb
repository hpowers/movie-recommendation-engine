class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :num, default: 0
      t.references :movie

      t.timestamps
    end
    add_index :tweets, :movie_id
  end
end
