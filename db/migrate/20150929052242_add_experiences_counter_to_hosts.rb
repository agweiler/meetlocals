class AddExperiencesCounterToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :experiences_count, :integer
  end
end
