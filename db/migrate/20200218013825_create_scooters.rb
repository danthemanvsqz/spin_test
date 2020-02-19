class CreateScooters < ActiveRecord::Migration[5.2]
  def change
    create_table :scooters do |t|
      t.geometry :location
      t.float :battery_level
      t.boolean :inactive

      t.timestamps
    end
  end
end
