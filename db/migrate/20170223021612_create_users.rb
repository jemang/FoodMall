class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :fullname
      t.string :username
      t.string :email
      t.string :role
      t.text :address
      t.string :password
      t.integer :phone

      t.timestamps
    end
  end
end
