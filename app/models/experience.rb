class Experience < ActiveRecord::Base
	belongs_to :host
	has_many :bookings
	has_many :images, as: :imageable, dependent: :destroy
end
