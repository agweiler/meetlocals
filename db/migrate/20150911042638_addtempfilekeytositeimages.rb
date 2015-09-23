class Addtempfilekeytositeimages < ActiveRecord::Migration
  def change
  	add_column :site_images, :temp_file_key, :string
  end
end
