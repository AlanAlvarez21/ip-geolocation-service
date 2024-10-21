class CreateGeolocations < ActiveRecord::Migration[7.2]
  def change
    create_table :geolocations do |t|
      t.string :ip
      t.string :city
      t.string :country
      t.decimal :latitude
      t.decimal :longitude
      t.string :provider

      t.timestamps
    end
  end
end
