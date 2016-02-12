class AddAgeToGuests < ActiveRecord::Migration
  def change
  	add_column :guests, :dob, :date
  end
end
