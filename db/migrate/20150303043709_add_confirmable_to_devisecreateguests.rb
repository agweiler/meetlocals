class AddConfirmableToDevisecreateguests < ActiveRecord::Migration
  def change
  	add_column :guests, :confirmation_token, :string
  	add_column :guests, :confirmed_at, :datetime
  	add_column :guests, :confirmation_sent_at, :datetime
  	add_index :guests, :confirmation_token, unique: true
  end
end
