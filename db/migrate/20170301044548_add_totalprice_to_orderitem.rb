class AddTotalpriceToOrderitem < ActiveRecord::Migration[5.0]
  def change
    add_column :orderitems, :totalprice, :float
  end
end
