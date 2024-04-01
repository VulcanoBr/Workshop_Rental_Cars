class CreateManufactures < ActiveRecord::Migration[7.1]
  def change
    create_table :manufactures do |t|
      t.string :name

      t.timestamps
    end
  end
end
