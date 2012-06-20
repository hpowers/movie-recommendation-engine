class CreateHsxDataPoints < ActiveRecord::Migration
  def change
    create_table :hsx_data_points do |t|
      t.float :price,      default: 0
      t.integer :gross,    default: 0
      t.integer :theaters, default: 0

      t.timestamps
    end
  end
end
