class AddDefaultNumToGuests < ActiveRecord::Migration
  def change
  	change_column :guests, :no_of_adults, :integer ,:default => 0
  	change_column :guests, :no_of_children, :integer, :default => 0
  end
end
