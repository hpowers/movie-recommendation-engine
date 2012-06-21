class CreateImdbData < ActiveRecord::Migration
  def change
    create_table :imdb_data do |t|
      t.text :title          , default: 0
      t.date :release        , default: 0
      t.integer :length      , default: 0
      t.integer :viewer      , default: 0
      t.integer :metacritic  , default: 0
      t.integer :movie_meter , default: 0
      t.integer :budget      , default: 0
      t.references :movie    , default: 0

      t.timestamps
    end
    add_index :imdb_data, :movie_id
  end
end
