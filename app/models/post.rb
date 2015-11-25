class Post < ActiveRecord::Base
	belongs_to :admin
	validates :title, presence: true
	validates :body,  presence: true
	has_many :images, as: :imageable
end
