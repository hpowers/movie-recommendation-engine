class CreateHsxData < ActiveRecord::Migration
  def change
    create_table :hsx_data do |t|
      t.float      :price    , default: 0.0
      t.integer    :gross    , default: 0
      t.integer    :theaters , default: 0
      t.references :movie    , default: 0

      t.timestamps
    end
    add_index :hsx_data, :movie_id
  end
end
