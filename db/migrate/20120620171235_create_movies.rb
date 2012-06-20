class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title, null: false
      t.boolean :default, default: false
      t.integer :score, default: 0

      t.timestamps
    end
    add_index :movies, :title, unique: true
    add_index :movies, :default
  end
end
