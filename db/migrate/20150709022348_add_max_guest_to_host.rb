class AddMaxGuestToHost < ActiveRecord::Migration
  def change
  	add_column :hosts, :max_group_size, :integer
  end
end
