class AddTempFileKeyToExpImages < ActiveRecord::Migration
  def change
  	add_column :exp_images, :temp_file_key, :string
  end
end
