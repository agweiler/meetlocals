class AddActiveToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :active, :boolean, default:true
  end
end
