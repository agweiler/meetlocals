class AddStuffToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :first_name, :string
    add_column :guests, :last_name, :string
    add_column :guests, :title, :string
    add_column :guests, :languages, :string
    add_column :guests, :nationality, :string
    add_column :guests, :country, :string
    add_column :guests, :province, :string
  end
end