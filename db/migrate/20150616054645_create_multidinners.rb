class CreateMultidinners < ActiveRecord::Migration
  def change
    create_table :multidinners do |t|
    	t.string :name
    	t.date :date
      t.timestamps null: false
    end
  end
end
