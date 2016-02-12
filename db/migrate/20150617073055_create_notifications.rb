class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
    	t.string   :content
    	t.datetime :created_at, null: false
    	t.datetime :updated_at, null: false
    	t.integer  :host_id
    	t.integer  :type_id
    	t.string   :type_of
    	t.boolean  :seen, default: false
      t.timestamps null: false
    end
  end
end
