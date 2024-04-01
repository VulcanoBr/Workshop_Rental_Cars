class AddTransactableRefToTransaction < ActiveRecord::Migration[7.1]
  def change
    add_reference :transactions, :transactable, polymorphic: true
  end
end
