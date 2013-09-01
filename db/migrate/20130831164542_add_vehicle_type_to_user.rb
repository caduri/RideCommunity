class AddVehicleTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :vehicle_type, :string
  end
end
