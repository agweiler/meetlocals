class Experience < ActiveRecord::Base
	belongs_to :host
	has_many :bookings
	has_many :images, as: :imageable, dependent: :destroy

	def self.get_location
    	return ["All","Kuala Lumpur", "Selangor", "Penang","Johor"]
	end
end
