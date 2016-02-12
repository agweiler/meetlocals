class AddMealsetToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :mealset, :string
  end
end
