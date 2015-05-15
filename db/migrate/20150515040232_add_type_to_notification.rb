class AddTypeToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :type_of, :string
    remove_column :notifications, :type, :string
  end
end
