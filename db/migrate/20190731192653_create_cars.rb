class CreateCars < ActiveRecord::Migration[7.1]
  def change
    create_table :cars do |t|
      t.references :car_model, foreign_key: true
      t.string :color
      t.string :license_plate
      t.integer :car_km
      t.references :subsidiary, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
