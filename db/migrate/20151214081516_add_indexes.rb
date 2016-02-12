class AddIndexes < ActiveRecord::Migration
  def change
 		add_index :bookings, :guest_id
 		add_index :bookings, :experience_id
 		add_index :experiences, :host_id
 		add_index :notifications, [:host_id, :type_of]
 		add_index :notifications, [:guest_id, :type_of]
 		add_index :posts, :post_type
  end
end
