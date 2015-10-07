class RemoveNoOfFromGuests < ActiveRecord::Migration
  def change
  	remove_column :guests, :no_of_adults, :integer
  	remove_column :guests, :no_of_children, :integer
  	remove_column :guests, :age_of_adults, :string
  	remove_column :guests, :age_of_children, :string
  end
end
