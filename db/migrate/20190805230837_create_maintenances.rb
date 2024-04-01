class CreateMaintenances < ActiveRecord::Migration[7.1]
  def change
    create_table :maintenances do |t|
      t.references :car, foreign_key: true
      t.references :provider, foreign_key: true
      
      t.string :invoice
      t.decimal :service_cost, precision: 12, scale: 2, default: 0.0
      t.datetime :maintenance_date

      t.timestamps
    end
  end
end
