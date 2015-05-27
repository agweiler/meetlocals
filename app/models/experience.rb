class Experience < ActiveRecord::Base
	belongs_to :host
	has_many :bookings
	has_many :images, as: :imageable, dependent: :destroy
	has_many :testimonials, through: :bookings

	scope :available, -> { where("date > ?", Date.today) }
	scope :normal_events, -> { where(date:nil) }
	scope :special_events, -> { where.not(date:nil).order(:date) }
	scope :special_events_dates,
	 -> { where.not(date:nil).pluck(:date).map {|date| date.strftime('%F') } }

	before_save :set_default_mealtime, :as_special_event

	def self.get_location
    	return ["Region","Zeeland", "Nordjylland", "Midtjylland","Syddanmark", "Hovedstaden"]
	end

  def max_number_in_group
    return (1..self.max_group_size).to_a
  end

	validates :title, :description, :cuisine, :max_group_size, :price,
	  presence: true

	# validate :available_days_must_have_minimum_one_day
	# def available_days_must_have_minimum_one_day
  # 	if available_days == "-------" && date.nil?
  #   	errors.add(:available_days, "should have at least 1 available day")
  # 	end
  # end

	def avg_rating
		self.testimonials.average(:rating).round(2)
	end

	def number_of_images
		self.images.count
	end

	validates :meal, presence: true
	def self.get_meals
		%w( Lunch Dinner )
	end

	def set_default_mealtime
		if self.meal == 'Lunch'
			self.time = Time.zone.local(2000, 01, 01, 12)
			self.duration = 2
			self.mealset = nil
		elsif self.meal == 'Dinner'
			self.time = Time.zone.local(2000, 01, 01, 19)
			self.duration = 3
		end
	end

	def is_dinner?
		self.meal == 'Dinner'
	end

	def as_special_event
		unless self.date.nil?
			self.available_days = "-------"
		end
	end

	def special_event?
		!self.date.nil?
	end

	def available?
		self.date.nil? || self.date > Date.today
	end

	validates :mealset, presence: true, if: :is_dinner?
	def self.get_mealsets
		["Starter + Main", "Main + Dessert"]
	end
end
