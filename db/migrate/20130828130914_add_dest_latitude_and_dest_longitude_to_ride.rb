class AddDestLatitudeAndDestLongitudeToRide < ActiveRecord::Migration
  def change
    add_column :rides, :destlatitude, :float
    add_column :rides, :destlongitude, :float
  end
end
