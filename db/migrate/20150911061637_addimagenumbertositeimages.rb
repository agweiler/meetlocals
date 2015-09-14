class Addimagenumbertositeimages < ActiveRecord::Migration
  def change
  	add_column :site_images, :image_number, :integer
  end
end
