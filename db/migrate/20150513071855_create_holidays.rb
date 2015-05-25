class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.date :date
      t.string :note
      t.references :host, index: true
      t.timestamps null: false
    end
  end
end
