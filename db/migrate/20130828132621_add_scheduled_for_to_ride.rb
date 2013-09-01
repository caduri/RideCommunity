class AddScheduledForToRide < ActiveRecord::Migration
  def change
    add_column :rides, :scheduledfor, :datetime
  end
end
