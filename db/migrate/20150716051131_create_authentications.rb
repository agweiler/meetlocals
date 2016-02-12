class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.references :guest
      t.string :provider
      t.string :uid
      t.timestamps null: false
    end
  end
end
