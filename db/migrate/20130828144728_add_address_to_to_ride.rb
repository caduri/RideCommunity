class AddAddressToToRide < ActiveRecord::Migration
  def change
    add_column :rides, :addressto, :string
  end
end
