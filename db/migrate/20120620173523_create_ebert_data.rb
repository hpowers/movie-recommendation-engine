class CreateEbertData < ActiveRecord::Migration
  def change
    create_table :ebert_data do |t|
      t.integer :stars, default: 0
      t.references :movie

      t.timestamps
    end
    add_index :ebert_data, :movie_id
  end
end
