class AddHostPaidToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :host_paid, :boolean, default: false
  end
end
