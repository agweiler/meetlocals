class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.string :title
      t.text :description
      t.float :duration
      t.boolean :is_halal
      t.string :cuisine
      t.integer :max_group_size
      t.text :host_style
      t.string :available_days
      t.float :price,            default: "0"
      t.integer :host_id,        null: false

      t.timestamps null: false
    end
  end
end
