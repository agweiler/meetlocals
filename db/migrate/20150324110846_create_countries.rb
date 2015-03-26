class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
    	t.string :name
      t.string :iso_two_letter_code 
      t.timestamps null: false
    end
  end
end
