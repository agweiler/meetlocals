class AddAboutToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :about, :text, default: ""
  end
end
