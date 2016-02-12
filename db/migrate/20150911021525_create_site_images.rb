class CreateSiteImages < ActiveRecord::Migration
  def change
    create_table :site_images do |t|
    	t.string :name
    	t.attachment :local_image
    	t.attachment :image_file 
      t.timestamps null: false
    end
  end
end
