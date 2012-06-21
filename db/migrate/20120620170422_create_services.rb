class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string  :name     , null: false
      t.integer :status   , default: 0
      t.integer :strength , default: 0

      t.timestamps
    end
  end
end
