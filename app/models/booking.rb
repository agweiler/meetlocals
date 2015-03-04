class Booking < ActiveRecord::Base
	belongs_to :guest
	belongs_to :experience
	has_one :testimonial
	has_many :messages
	
	def self.update_status(status)
		case status
		# when "Requested" #default
		when "Invite"
			status.replace("invited")
		when "Reject"
			status.replace("rejected")
		when "Complete"
			status.replace("completed")
		end
		status
	end

	def self.statuses
		["Invite", "Reject", "Complete"]
	end
end
