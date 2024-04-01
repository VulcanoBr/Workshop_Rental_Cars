class CreateInspections < ActiveRecord::Migration[7.1]
  def change
    create_table :inspections do |t|
      t.integer :fuel_level
      t.integer :cleanance_level
      t.text :damages
      t.references :car, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
