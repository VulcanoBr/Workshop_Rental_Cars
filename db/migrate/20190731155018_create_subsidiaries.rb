class CreateSubsidiaries < ActiveRecord::Migration[7.1]
  def change
    create_table :subsidiaries do |t|
      t.string :name

      t.timestamps
    end
  end
end
