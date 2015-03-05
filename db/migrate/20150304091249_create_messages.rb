class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :text
      t.integer :sender_id
      t.string :sender_type

      t.integer :booking_id
      t.timestamps null: false
    end
  end
end
