class CreateSetdefaults < ActiveRecord::Migration[5.0]
  def change
    create_table :setdefaults do |t|
      t.integer :chef
      t.integer :runner
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
