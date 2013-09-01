class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :content
      t.boolean :seen
      t.integer :user_id

      t.timestamps
    end
  end
end
