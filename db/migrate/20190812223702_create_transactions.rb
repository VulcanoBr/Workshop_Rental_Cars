class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.decimal :amount, precision: 12, scale: 2, default: 0.0
      t.string :type

      t.references :subsidiary, foreign_key: true

      t.timestamps
    end
  end
end
