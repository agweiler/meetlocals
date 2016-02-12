class CreateStaticTexts < ActiveRecord::Migration
  def change
    create_table :static_texts do |t|
      t.string :name
      t.string :content
      t.timestamps null: false
    end
  end
end
