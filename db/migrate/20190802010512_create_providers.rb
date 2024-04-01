class CreateProviders < ActiveRecord::Migration[7.1]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :cnpj
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
