class RenameDobToLowercase < ActiveRecord::Migration
  def change
    rename_column :hosts, :dob, :dob
  end
end
