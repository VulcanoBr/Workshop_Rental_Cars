class CreateFines < ActiveRecord::Migration[7.1]
  def change
    create_table :fines do |t|
      t.date :issued_on
      t.integer :demerit_points
      t.decimal :fine_value, precision: 12, scale: 2, default: 0.0
      t.string :address
      t.references :car, foreign_key: true

      t.timestamps
    end
  end
end
