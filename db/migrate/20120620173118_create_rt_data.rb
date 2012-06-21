class CreateRtData < ActiveRecord::Migration
  def change
    create_table :rt_data do |t|
      t.date       :release_date
      t.integer    :runtime           , default: 0
      t.string     :mpaa_rating
      t.text       :critics_consensus
      t.integer    :critics_score     , default: 0
      t.integer    :audience_score    , default: 0
      t.references :movie

      t.timestamps
    end
    add_index :rt_data, :movie_id
  end
end
