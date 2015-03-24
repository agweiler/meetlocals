class AddStuffToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :first_name, :string
    add_column :hosts, :last_name, :string
    add_column :hosts, :title, :string
    add_column :hosts, :languages, :string
    add_column :hosts, :street_address, :string
    add_column :hosts, :intro, :text
    add_column :hosts, :neighbourhood, :text
    add_column :hosts, :additional_info, :text
  end
end