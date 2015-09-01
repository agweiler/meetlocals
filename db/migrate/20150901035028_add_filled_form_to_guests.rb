class AddFilledFormToGuests < ActiveRecord::Migration
  def change
  	add_column :guests, :filled, :boolean, null: false, default: false
  end
end
