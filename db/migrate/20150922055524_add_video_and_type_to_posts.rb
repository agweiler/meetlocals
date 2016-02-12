class AddVideoAndTypeToPosts < ActiveRecord::Migration
  def change
  	add_column :posts, :video_url, :string
  	add_column :posts, :post_type, :string
  end
end
