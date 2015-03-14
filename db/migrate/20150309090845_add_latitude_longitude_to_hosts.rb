class AddLatitudeLongitudeToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :latitude, :float
    add_column :hosts, :longitude, :float
  end
end
