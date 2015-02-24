class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.string :link
      t.string :caption
      t.string :alt_text
      t.string :imageable_type
      t.integer :imageable_id

      t.timestamps null: false
    end
  end
end
