class RemoveProvinceFromGuest < ActiveRecord::Migration
  def change
  	remove_column :guests, :province
  end
end
