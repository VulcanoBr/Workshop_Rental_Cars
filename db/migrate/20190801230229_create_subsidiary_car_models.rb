class CreateSubsidiaryCarModels < ActiveRecord::Migration[7.1]
  def change
    create_table :subsidiary_car_models do |t|
      t.decimal :price, precision: 10, scale: 2, default: 0.0
      t.references :subsidiary, foreign_key: true
      t.references :car_model, foreign_key: true

      t.timestamps
    end
  end
end
