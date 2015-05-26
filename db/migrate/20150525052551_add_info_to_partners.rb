class AddInfoToPartners < ActiveRecord::Migration
  def change
  	 add_column :partners, :name, :string
  	 add_column :partners, :address, :string
  	 add_column :partners, :contact_info, :string
  end
end
