class AddMealExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :meal, :string
  end
end
