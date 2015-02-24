class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.time :start_time
      t.time :end_time
      t.date :date
      t.integer :guest_id
      t.integer :experience_id
      t.string :status
      t.integer :group_size
      t.boolean :is_private

      t.timestamps null: false
    end
  end
end
