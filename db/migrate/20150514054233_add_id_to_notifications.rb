class AddIdToNotifications < ActiveRecord::Migration
  def change
  	add_column :notifications, :host_id, :integer
  end
end
