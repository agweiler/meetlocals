class AddRevenueToHosts < ActiveRecord::Migration
  def change
  	add_column :hosts, :revenue, :decimal, :precision => 8, :scale => 2, default: 0.00
  end
end
