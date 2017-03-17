class CreateTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :templates do |t|
      t.integer :quantity
      t.string :day
      t.datetime :dtime
      t.float :total
      t.text :note
      t.integer :runner_id
      t.integer :chef_id
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true

      t.timestamps
    end
  end
end
