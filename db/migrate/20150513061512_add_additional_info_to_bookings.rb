class AddAdditionalInfoToBookings < ActiveRecord::Migration
  def change
  	add_column :bookings, :add_info, :text
  end
end
