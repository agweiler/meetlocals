class Booking < ActiveRecord::Base
	belongs_to :guest
	belongs_to :experience
	has_one :testimonial
	has_many :messages

	validates :guest_id, :experience_id, :date, presence: true
	validate :group_size_must_not_exceed_maximum

	scope :confirmed, -> { where(status: 'confirmed') }

	def group_size_must_not_exceed_maximum
		max = self.experience.max_group_size
		unless (max >= 0 && max == nil)
			if self.group_size > self.experience.max_group_size
				errors.add(:group_size, "cannot exceed maximum (#{max} people)")
			end
		end
	end

	def self.update_status(status)
		case status.downcase
		# when "Requested" #default
		when "invite"
			status.replace("invited")
		when "reject"
			status.replace("rejected")
		when "confirm"
			status.replace("confirmed")
		when "complete"
			status.replace("completed")
		end
		status
	end

	def mark_as_complete
		status.replace("completed")
		@guest = self.guest
		@booking_id = self.id
		Guestmailer.experience_completed(@booking_id, @guest.id).deliver_now
		save
	end

	def check_finished?
		Time.now >= self.date && Time.now.hour > (self.start_time + self.experience.duration.hour).hour
	end

#Here we need to make this trigger the booking status as complete, rather than render a "complete" button.

	def self.statuses
		["Invite", "Reject", "Complete"]
	end

	def self.confirmed_dates
		self.confirmed.map { |book| book.date.strftime('%F') }
	end

	# DO STUFF HERE MON
	serialize :notification_params, Hash
	def paypal_url(return_path)
	@experience = Experience.find(self.experience_id)
	values = {
	    business: "thenasiproject-facilitator@gmail.com ",
	    cmd: "_xclick",
	    upload: 1,
	    return: "#{Rails.application.secrets.app_host}#{return_path}",
	    invoice: "#{id}" + (0...8).map { (65 + rand(26)).chr }.join,
	    amount: @experience.price,
	    item_name: "#{@experience.title} experience booking",
	    item_number: @experience.id,
	    quantity: self.group_size,
	    notify_url: "#{Rails.application.secrets.app_host}/hook"
	}

	"#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
	end
end
