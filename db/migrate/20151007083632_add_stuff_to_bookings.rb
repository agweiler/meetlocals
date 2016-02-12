class AddStuffToBookings < ActiveRecord::Migration
  def change
  	add_column :bookings, :no_of_adults, :integer ,:default => 0
  	add_column :bookings, :no_of_children, :integer ,:default => 0
  end
end
