class AddPaperclipFieldsToExpimages < ActiveRecord::Migration
  def change
  	add_attachment :exp_images, :local_image  
  	add_attachment :exp_images, :image_file  
  end
end
