class AddDtimeToOrderitem < ActiveRecord::Migration[5.0]
  def change
    add_column :orderitems, :dtime, :datetime
  end
end
