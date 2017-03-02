class AddChefIdToOrderitem < ActiveRecord::Migration[5.0]
  def change
    add_column :orderitems, :chef_id, :integer
  end
end
