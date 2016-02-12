class Testimonial < ActiveRecord::Base
	belongs_to :booking
	has_many :images, as: :imageable
end
