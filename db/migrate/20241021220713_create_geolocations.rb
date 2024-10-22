class CreateGeolocations < ActiveRecord::Migration[7.2]
  def change
    create_table :geolocations do |t|
      t.string :ip
      t.string :input
      t.string :city
      t.string :country
      t.decimal :latitude
      t.decimal :longitude
      t.string :provider
      t.string :type_of_ip
      t.string :ip_version
      t.string :continent_code
      t.string :continent_name
      t.string :country_code
      t.string :country_name
      t.string :region_code
      t.string :region_name
      t.string :zip
      t.string :msa
      t.string :dma
      t.string :ip_routing_type
      t.string :connection_type
      t.integer :geoname_id
      t.string :capital
      t.string :country_flag
      t.string :country_flag_emoji
      t.string :calling_code
      t.boolean :is_eu

      t.timestamps
    end
  end
end