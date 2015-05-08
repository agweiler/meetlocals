class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
    	t.string :meal
      t.float :price
    end
  end
end
