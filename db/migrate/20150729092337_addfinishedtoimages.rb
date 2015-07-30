class Addfinishedtoimages < ActiveRecord::Migration
  def change
  	add_column :images, :finished, :boolean
  end
end
