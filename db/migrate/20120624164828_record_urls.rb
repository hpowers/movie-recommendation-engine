class RecordUrls < ActiveRecord::Migration
  def change
    add_column :imdb_data, :url, :string, default: '', null: false
    add_column :hsx_data, :url, :string, default: '', null: false
  end
end
