class AddDateToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :date, :date
  end
end
