class AddVehicleTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :Vvhicle_type, :string
  end
end
