class CreateRentals < ActiveRecord::Migration[7.1]
  def change
    create_table :rentals do |t|
      t.references :car, foreign_key: true
      t.references :user, foreign_key: true
      t.references :customer, foreign_key: true

      t.string :rented_code
      t.decimal :daily_price, default: 0.0
      t.datetime :start_at
      t.datetime :finished_at
      t.integer :status, default: 0

      t.date :scheduled_start
      t.date :scheduled_end
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps
    end
  end
end
