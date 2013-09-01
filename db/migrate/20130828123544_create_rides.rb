class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.float :latitude
      t.float :longitude
      t.string :comment
      t.integer :user_id

      t.timestamps
    end
  end
end
