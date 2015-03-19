class Post < ActiveRecord::Base
	belongs_to :admin
	validates :title, presence: true, length: {minimum: 5}
	validates :body,  presence: true
  has_attached_file :image, :styles => { :full =>"1200*800!", :large =>"600x600>", :medium => "300x300>", :thumb => "100x100>" }, :default_url => ""
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
