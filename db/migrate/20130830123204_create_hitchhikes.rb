class CreateHitchhikes < ActiveRecord::Migration
  def change
    create_table :hitchhikes do |t|
      t.integer :ride_id
      t.integer :user_id

      t.timestamps
    end

    add_index :hitchhikes, [:ride_id, :user_id], unique: true
  end
end
