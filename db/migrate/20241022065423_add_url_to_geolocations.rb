class AddUrlToGeolocations < ActiveRecord::Migration[7.2]
  def change
    add_column :geolocations, :url, :string
  end
end
