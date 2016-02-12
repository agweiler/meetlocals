class AddBeverageToExperiences < ActiveRecord::Migration
  def change
  	add_column :experiences, :beverages, :string
  end
end