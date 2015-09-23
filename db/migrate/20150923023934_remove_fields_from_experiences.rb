class RemoveFieldsFromExperiences < ActiveRecord::Migration
  def change
  	remove_column :experiences, :description
  end
end
