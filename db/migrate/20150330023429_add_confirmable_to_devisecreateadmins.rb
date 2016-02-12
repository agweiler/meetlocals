class AddConfirmableToDevisecreateadmins < ActiveRecord::Migration
  def change
  		add_column :admins, :confirmation_token, :string
  	add_column :admins, :confirmed_at, :datetime
  	add_column :admins, :confirmation_sent_at, :datetime
  	add_index :admins, :confirmation_token, unique: true
  end
end
