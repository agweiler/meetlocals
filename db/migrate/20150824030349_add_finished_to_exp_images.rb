class AddFinishedToExpImages < ActiveRecord::Migration
  def change
  	add_column :exp_images, :finished, :boolean
  end
end
