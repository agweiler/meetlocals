class AddCommisionsToAdmin < ActiveRecord::Migration
  def change
  	add_column :admins, :commision_percentage, :integer, default: 10
  end
end
