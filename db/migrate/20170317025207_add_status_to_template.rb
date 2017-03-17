class AddStatusToTemplate < ActiveRecord::Migration[5.0]
  def change
    add_column :templates, :status, :string
  end
end
