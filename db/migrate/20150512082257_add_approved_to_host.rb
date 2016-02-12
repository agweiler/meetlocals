class AddApprovedToHost < ActiveRecord::Migration
  def change
    add_column :hosts, :approved, :boolean, :default => false, :null => false
  end
end
