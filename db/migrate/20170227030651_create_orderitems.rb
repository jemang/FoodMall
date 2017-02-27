class CreateOrderitems < ActiveRecord::Migration[5.0]
  def change
    create_table :orderitems do |t|
      t.integer :quantity
      t.text :note
      t.float :total
      t.string :status
      t.references :item
      t.references :user

      t.timestamps
    end
  end
end
