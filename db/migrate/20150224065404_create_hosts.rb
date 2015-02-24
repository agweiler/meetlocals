class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.string :username
      t.string :email
      t.string :password
      t.date :DOB
      t.string :country
      t.string :state
      t.string :suburb

      t.timestamps null: false
    end
  end
end
