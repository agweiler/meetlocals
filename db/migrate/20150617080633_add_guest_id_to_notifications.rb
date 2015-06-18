class AddGuestIdToNotifications < ActiveRecord::Migration
  def change
  	add_column :notifications, :guest_id, :integer
  end
end
