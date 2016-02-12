class AddMoreStuffToGuests < ActiveRecord::Migration
  def change
  	add_column :guests, :profession, :string
  	add_column :guests, :no_of_adults, :integer
  	add_column :guests, :no_of_children, :integer
  	add_column :guests, :age_of_adults, :string
  	add_column :guests, :age_of_children, :string
  end
end
