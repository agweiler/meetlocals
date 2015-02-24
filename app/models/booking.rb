class Booking < ActiveRecord::Base
	belongs_to :guest
	belongs_to :experience
	has_one :testimonial
end
