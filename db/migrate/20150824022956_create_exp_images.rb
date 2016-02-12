class CreateExpImages < ActiveRecord::Migration
  def change
    create_table :exp_images do |t|
    	t.integer :experience_id
    	t.integer :image_number
      t.timestamps null: false
    end
  end
end
