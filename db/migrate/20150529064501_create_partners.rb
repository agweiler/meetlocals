class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :name
  	  t.string :address
  	  t.string :contact_info, :string
      t.timestamps null: false
    end
  end
end
