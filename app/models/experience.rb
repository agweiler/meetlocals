class Experience < ActiveRecord::Base
	belongs_to :host
	has_many :bookings
	has_many :images, as: :imageable, dependent: :destroy


	def self.get_location
    	return ["All","Kuala Lumpur", "Selangor", "Penang","Johor"]
	end

	validates :title, presence: true
	validate :available_days_must_have_minimum_one_day

	def available_days_must_have_minimum_one_day
    	if available_days == "-------"
      		errors.add(:available_days, "should have at least 1 available day")
    	end
 	end

end
