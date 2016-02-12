class RemoveFieldsFromHost < ActiveRecord::Migration
  def change
  	remove_column :hosts, :intro
  	remove_column :hosts, :additional_info
  end
end
