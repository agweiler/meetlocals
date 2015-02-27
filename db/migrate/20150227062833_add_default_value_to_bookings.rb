class AddDefaultValueToBookings < ActiveRecord::Migration
  def change
    change_column :bookings, :status, :string, default: "requested"
  end
end
