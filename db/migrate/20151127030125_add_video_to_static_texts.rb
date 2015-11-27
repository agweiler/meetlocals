class AddVideoToStaticTexts < ActiveRecord::Migration
  def change
    add_column :static_texts, :video_url, :string
  end
end
