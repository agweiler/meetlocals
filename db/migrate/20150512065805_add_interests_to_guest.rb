class AddInterestsToGuest < ActiveRecord::Migration
  def change
    add_column :guests, :interests, :text
    add_column :guests, :allergies, :string
  end
end
