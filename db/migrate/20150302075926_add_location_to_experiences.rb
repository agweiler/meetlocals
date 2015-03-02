class AddLocationToExperiences < ActiveRecord::Migration
  def change
  	add_column :experiences, :location, :string
  end
end
