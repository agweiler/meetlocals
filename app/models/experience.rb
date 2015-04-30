class Experience < ActiveRecord::Base
	belongs_to :host
	has_many :bookings
	has_many :images, as: :imageable, dependent: :destroy

	has_many :testimonials, through: :bookings


	def self.get_location
    	return ["All","Zeeland", "Nordjylland", "Midtjylland","Syddanmark", "Hovedstaden"]
	end

  def max_number_in_group
    return (1..self.max_group_size).to_a
  end

	validates :title, :description, :cuisine, :max_group_size, :duration, :price, :images, presence: true
	validate :available_days_must_have_minimum_one_day

	def available_days_must_have_minimum_one_day
    	if available_days == "-------"
      		errors.add(:available_days, "should have at least 1 available day")
    	end
 	end

	def avg_rating
		self.testimonials.average(:rating).round(2)
	end

end
