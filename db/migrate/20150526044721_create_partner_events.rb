class CreatePartnerEvents < ActiveRecord::Migration
  def change
    create_table :partner_events do |t|
      t.string :event_name
    	t.integer :no_of_guests
    	t.integer :no_of_hosts
    	t.string :partner_name
    	t.string :location
    	t.date   :date
      t.timestamps null: false
    end
  end
end
