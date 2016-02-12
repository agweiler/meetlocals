class AddDefaultValueToExperiencesAvailableDays < ActiveRecord::Migration
  def change
    change_column :experiences, :available_days, :string, default: "-------"
  end
end
