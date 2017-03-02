class AddRunnerIdToOrderitem < ActiveRecord::Migration[5.0]
  def change
    add_column :orderitems, :runner_id, :integer
  end
end
