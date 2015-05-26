class RenameDobToLowercase < ActiveRecord::Migration
  def change
    rename_column :hosts, :DOB, :dob
  end
end
