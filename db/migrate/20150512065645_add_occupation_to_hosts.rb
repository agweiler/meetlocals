class AddOccupationToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :occupation, :string
    add_column :hosts, :interests, :text
    add_column :hosts, :smoker, :boolean
    add_column :hosts, :pets, :string
  end
end
