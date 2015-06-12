class Addtempfilekeytoimages < ActiveRecord::Migration
  def change
  	 add_column :images, :temp_file_key, :string
  end
end
