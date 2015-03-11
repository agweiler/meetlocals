class AddTimeToExperience < ActiveRecord::Migration
  def change
    add_column :experiences, :time, :time
  end
end
