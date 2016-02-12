class Addarraystomultidinners < ActiveRecord::Migration
  def change
  	add_column :multidinners, :group_sizes, :string, array:true, default: []
  	add_column :multidinners, :hosts_chosen, :string, array:true, default: []
  end
end
