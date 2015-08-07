class Changenametousernameforpartner < ActiveRecord::Migration
  def change
  	rename_column :partners, :name, :username
  end
end
