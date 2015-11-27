class ChangeStringToTextInStatictexts < ActiveRecord::Migration
  def change
  	change_column(:static_texts, :content, :text)
  end
end
